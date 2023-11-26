--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              INTERFACE FUNCTIONS                                           --
--                                                                                            --
--============================================================================================--
--============================================================================================--

---------------------------------------------------------------------------------
--
-- Start dragging the shard button
-- 
---------------------------------------------------------------------------------
function ShardTracker_OnDragStart()
    if (not ShardTracker_DragLock and not ShardTracker_BeingDragged) then
        this:StartMoving();
        ShardTracker_BeingDragged = true;
    else
        ShardTrackerPrint(ST_DRAGERROR);
    end
end


---------------------------------------------------------------------------------
--
-- Stop dragging the shard button
-- 
---------------------------------------------------------------------------------
function ShardTracker_OnDragStop()
    if (ShardTracker_BeingDragged) then
        this:StopMovingOrSizing()
        ShardTracker_BeingDragged = false;
        local x,y = this:GetCenter();
        local px, py = this:GetParent():GetCenter();
        local ox, oy = ShardTracker_CalcOffsetGivenScaledCoords(this:GetName(), x, y);
        ShardTrackerDebug(" Name = "..this:GetName().."  ParentName = "..this:GetParent():GetName());
        ShardTrackerDebug("   ShardTrackerMinimapButton:GetParent():GetName() = "..this:GetParent():GetName());
        ShardTrackerDebug("   Center        : x = "..x.." y = "..y);
        ShardTrackerDebug("   Parent Center : px = "..px.." py = "..py);
        ShardTrackerDebug("   Offset        : ox = "..ox.." oy = "..oy);
        ShardTracker_StoreButtonLocation(this:GetName(), ox, oy);
    end
end


---------------------------------------------------------------------------------
--
-- Register the button for drag
-- 
---------------------------------------------------------------------------------
function ShardTracker_ButtonOnLoad()
    this:RegisterForDrag("LeftButton");
end


---------------------------------------------------------------------------------
--
-- Toggle the lock / unlock status of the interface
-- 
---------------------------------------------------------------------------------
function ShardTracker_ToggleLockedForDragging(theCommand)
    if (theCommand == SHARDTRACKER_LOCK_CMD) then
        ShardTracker_DragLock = true;
        ShardTrackerPrint(ST_LOCKMSG);
    elseif (theCommand == SHARDTRACKER_UNLOCK_CMD) then
        ShardTracker_DragLock = false;
        ShardTrackerPrint(ST_UNLOCKMSG);
    end
end


---------------------------------------------------------------------------------
--
-- Store the location of the specified button, relative to its parent in the XML
-- 
---------------------------------------------------------------------------------
function ShardTracker_StoreButtonLocation(buttonName, ox, oy)

    local scaleFactor = ShardTracker_GetButtonScaleValue(SHARDTRACKER_CONFIG.BUTTONSCALE) / SHARDTRACKER_SCALE_1;

    ox = ox / scaleFactor;
    oy = oy / scaleFactor;
    
    if (buttonName == "ShardTrackerMinimapButton") then
        SHARDTRACKER_CONFIG.SHARDBUTTONX = ox;
        SHARDTRACKER_CONFIG.SHARDBUTTONY = oy;
    elseif (buttonName == "ShardTrackerMinimapButtonHealth") then
        SHARDTRACKER_CONFIG.HEALTHBUTTONX = ox;
        SHARDTRACKER_CONFIG.HEALTHBUTTONY = oy;
    elseif (buttonName == "ShardTrackerMinimapButtonSoul") then
        SHARDTRACKER_CONFIG.SOULBUTTONX = ox;
        SHARDTRACKER_CONFIG.SOULBUTTONY = oy;
    elseif (buttonName == "ShardTrackerMinimapButtonSpell") then
        SHARDTRACKER_CONFIG.SPELLBUTTONX = ox;
        SHARDTRACKER_CONFIG.SPELLBUTTONY = oy;
    elseif (buttonName == "ShardTrackerMinimapButtonFire") then
        SHARDTRACKER_CONFIG.FIREBUTTONX = ox;
        SHARDTRACKER_CONFIG.FIREBUTTONY = oy;
    end    
end


---------------------------------------------------------------------------------
--
-- Move the interface buttons to the stored locations
-- 
---------------------------------------------------------------------------------
function ShardTracker_ButtonSetLocation()

    ShardTrackerMinimapButton:ClearAllPoints();
    ShardTrackerMinimapButtonHealth:ClearAllPoints();
    ShardTrackerMinimapButtonSoul:ClearAllPoints();
    ShardTrackerMinimapButtonSpell:ClearAllPoints();
    ShardTrackerMinimapButtonFire:ClearAllPoints();

    ShardTrackerDebug("Setting Shard Button Location:  x = "..SHARDTRACKER_CONFIG.SHARDBUTTONX.."  y = "..SHARDTRACKER_CONFIG.SHARDBUTTONY);
    local px, py = ShardTrackerMinimapButton:GetParent():GetCenter();
    ShardTrackerDebug("ShardTrackerMinimapButton:GetParent():GetCenter(): x = "..px.."  y = "..py);
    ShardTrackerMinimapButton:SetPoint("CENTER", ShardTrackerMinimapButton:GetParent():GetName(), "CENTER", SHARDTRACKER_CONFIG.SHARDBUTTONX, SHARDTRACKER_CONFIG.SHARDBUTTONY);
    ShardTrackerMinimapButtonHealth:SetPoint("CENTER", ShardTrackerMinimapButtonHealth:GetParent():GetName(), "CENTER", SHARDTRACKER_CONFIG.HEALTHBUTTONX, SHARDTRACKER_CONFIG.HEALTHBUTTONY);
    ShardTrackerMinimapButtonSoul:SetPoint("CENTER", ShardTrackerMinimapButtonSoul:GetParent():GetName(), "CENTER", SHARDTRACKER_CONFIG.SOULBUTTONX, SHARDTRACKER_CONFIG.SOULBUTTONY);
    ShardTrackerMinimapButtonSpell:SetPoint("CENTER", ShardTrackerMinimapButtonSpell:GetParent():GetName(), "CENTER", SHARDTRACKER_CONFIG.SPELLBUTTONX, SHARDTRACKER_CONFIG.SPELLBUTTONY);
    ShardTrackerMinimapButtonFire:SetPoint("CENTER", ShardTrackerMinimapButtonFire:GetParent():GetName(), "CENTER", SHARDTRACKER_CONFIG.FIREBUTTONX, SHARDTRACKER_CONFIG.FIREBUTTONY);

end


---------------------------------------------------------------------------------
--
-- Move the interface buttons back to their default locations
-- 
---------------------------------------------------------------------------------
function ShardTracker_ResetButtonLocations(centerButtons)

    local scaleFactor = ShardTracker_GetButtonScaleValue(SHARDTRACKER_CONFIG.BUTTONSCALE) / SHARDTRACKER_SCALE_1;

    ShardTrackerPrint("Button locations reset.");
    SHARDTRACKER_CONFIG.SHARDBUTTONX                = SHARDTRACKER_ORIG_SHARDBUTTONX / scaleFactor;    
    SHARDTRACKER_CONFIG.SHARDBUTTONY                = SHARDTRACKER_ORIG_SHARDBUTTONY / scaleFactor;
    SHARDTRACKER_CONFIG.HEALTHBUTTONX               = SHARDTRACKER_ORIG_HEALTHBUTTONX / scaleFactor;
    SHARDTRACKER_CONFIG.HEALTHBUTTONY               = SHARDTRACKER_ORIG_HEALTHBUTTONY / scaleFactor;
    SHARDTRACKER_CONFIG.SOULBUTTONX                 = SHARDTRACKER_ORIG_SOULBUTTONX / scaleFactor;
    SHARDTRACKER_CONFIG.SOULBUTTONY                 = SHARDTRACKER_ORIG_SOULBUTTONY / scaleFactor;
    SHARDTRACKER_CONFIG.SPELLBUTTONX                = SHARDTRACKER_ORIG_SPELLBUTTONX / scaleFactor;
    SHARDTRACKER_CONFIG.SPELLBUTTONY                = SHARDTRACKER_ORIG_SPELLBUTTONY / scaleFactor;
    SHARDTRACKER_CONFIG.FIREBUTTONX                 = SHARDTRACKER_ORIG_FIREBUTTONX / scaleFactor;
    SHARDTRACKER_CONFIG.FIREBUTTONY                 = SHARDTRACKER_ORIG_FIREBUTTONY / scaleFactor;
    ShardTracker_ButtonSetLocation();
end


---------------------------------------------------------------------------------
--
-- Move the interface buttons to the center of the screen
-- 
---------------------------------------------------------------------------------
function ShardTracker_CenterButtonLocations()

    ShardTrackerPrint("Button locations set to center of screen.");
    SHARDTRACKER_CONFIG.SHARDBUTTONX                = SHARDTRACKER_CNTR_SHARDBUTTONX;    
    SHARDTRACKER_CONFIG.SHARDBUTTONY                = SHARDTRACKER_CNTR_SHARDBUTTONY;
    SHARDTRACKER_CONFIG.HEALTHBUTTONX               = SHARDTRACKER_CNTR_HEALTHBUTTONX;
    SHARDTRACKER_CONFIG.HEALTHBUTTONY               = SHARDTRACKER_CNTR_HEALTHBUTTONY;
    SHARDTRACKER_CONFIG.SOULBUTTONX                 = SHARDTRACKER_CNTR_SOULBUTTONX;
    SHARDTRACKER_CONFIG.SOULBUTTONY                 = SHARDTRACKER_CNTR_SOULBUTTONY;
    SHARDTRACKER_CONFIG.SPELLBUTTONX                = SHARDTRACKER_CNTR_SPELLBUTTONX;
    SHARDTRACKER_CONFIG.SPELLBUTTONY                = SHARDTRACKER_CNTR_SPELLBUTTONY;
    SHARDTRACKER_CONFIG.FIREBUTTONX                 = SHARDTRACKER_CNTR_FIREBUTTONX;
    SHARDTRACKER_CONFIG.FIREBUTTONY                 = SHARDTRACKER_CNTR_FIREBUTTONY;
    ShardTracker_ButtonSetLocation();
end


---------------------------------------------------------------------------------
--
-- Calculate the offset of the button based on its scale
-- 
---------------------------------------------------------------------------------
function ShardTracker_CalcOffsetGivenScaledCoords(theElement, x, y)
    ShardTrackerDebug("Scaling for **"..theElement.."**  with x = "..x.."  y = "..y);
    ShardTrackerDebug("   scale = "..ShardTracker_GetButtonScaleValue(SHARDTRACKER_CONFIG.BUTTONSCALE));
    ShardTrackerDebug("   basescale = "..SHARDTRACKER_SCALE_1);
    scaleFactor = ShardTracker_GetButtonScaleValue(SHARDTRACKER_CONFIG.BUTTONSCALE) / SHARDTRACKER_SCALE_1;
    ShardTrackerDebug("   scaleFactor = "..scaleFactor);
    x = x * scaleFactor;
    y = y * scaleFactor;
    ShardTrackerDebug("   scaledx = "..x.."  scaledy = "..y);
    px, py = getglobal(theElement):GetParent():GetCenter();
    ShardTrackerDebug("   parentx = "..px.."  parenty = "..py);
    xoffset = x - px;
    yoffset = y - py;
    ShardTrackerDebug("   xoffset = "..xoffset.."  yoffset = "..yoffset);
    return xoffset, yoffset;    
end

function ShardTracker_TestSetButtonLoc(var)
    a, b, x, y = string.find(var, "([%d-]+) ([%d-]+)");
    x = tonumber(x);
    y = tonumber(y);

    ShardTrackerMinimapButton:SetPoint("CENTER", ShardTrackerMinimapButton:GetParent():GetName(), "CENTER", x, y);
end


function ShardTracker_PrintButtonLocs()
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SHARDBUTTONX = "..SHARDTRACKER_CONFIG.SHARDBUTTONX);
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SHARDBUTTONY = "..SHARDTRACKER_CONFIG.SHARDBUTTONY);
    ShardTrackerDebug("SHARDTRACKER_CONFIG.HEALTHBUTTONX = "..SHARDTRACKER_CONFIG.HEALTHBUTTONX);
    ShardTrackerDebug("SHARDTRACKER_CONFIG.HEALTHBUTTONY = "..SHARDTRACKER_CONFIG.HEALTHBUTTONY);
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SOULBUTTONX = "..SHARDTRACKER_CONFIG.SOULBUTTONX);
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SOULBUTTONY = "..SHARDTRACKER_CONFIG.SOULBUTTONY);
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SPELLBUTTONX = "..SHARDTRACKER_CONFIG.SPELLBUTTONX);
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SPELLBUTTONY = "..SHARDTRACKER_CONFIG.SPELLBUTTONY);  
    ShardTrackerDebug("SHARDTRACKER_CONFIG.FIREBUTTONX = "..SHARDTRACKER_CONFIG.FIREBUTTONX);
    ShardTrackerDebug("SHARDTRACKER_CONFIG.FIREBUTTONY = "..SHARDTRACKER_CONFIG.FIREBUTTONY);  

    ShardTrackerDebug("Centers:");
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SHARDBUTTON X = "..ShardTrackerMinimapButton:GetCenter());
    ShardTrackerDebug("SHARDTRACKER_CONFIG.HEALTHBUTTON X = "..ShardTrackerMinimapButtonHealth:GetCenter());
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SOULBUTTON X = "..ShardTrackerMinimapButtonSoul:GetCenter());
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SPELLBUTTON X = "..ShardTrackerMinimapButtonSpell:GetCenter());
    ShardTrackerDebug("SHARDTRACKER_CONFIG.FIREBUTTON X = "..ShardTrackerMinimapButtonFire:GetCenter());

    ShardTrackerDebug("Parent is: "..ShardTrackerMinimapButton:GetParent():GetName());
    ShardTrackerDebug("Parent's center X is: "..ShardTrackerMinimapButton:GetParent():GetCenter());
    ShardTrackerDebug("Button X minus Parent's center X is: "..ShardTrackerMinimapButton:GetCenter() - ShardTrackerMinimapButton:GetParent():GetCenter());
    
    ShardTrackerDebug("Visibility:");
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SHARDBUTTON visible = "..tostring(ShardTrackerMinimapButton:IsVisible()));
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SHARDBUTTON shown = "..tostring(ShardTrackerMinimapButton:IsShown()));
    ShardTrackerDebug("SHARDTRACKER_CONFIG.SHARDBUTTON enabled = "..tostring(ShardTrackerMinimapButton:IsEnabled()));
end


---------------------------------------------------------------------------------
--
-- Show the tooltip text
-- 
---------------------------------------------------------------------------------
function ShardTracker_ShowShardButtonTooltip(theText1, theText2, theText3, theText4, theText5)

    -- Set the anchor and text for the tooltip.
    ShardTracker_MoneyToggle();
    ShardTracker_ClearTooltip("GameTooltip");
    ShardTracker_MoneyToggle();

    local x,y = this:GetCenter();
    if (x > GetScreenWidth()/2) then
        ShardTracker_MoneyToggle();    
        GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
        ShardTracker_MoneyToggle();
    else
        ShardTracker_MoneyToggle();    
        GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
        ShardTracker_MoneyToggle();
    end
    
    ShardTracker_MoneyToggle();
    GameTooltip:SetText(theText1, 0.39, 0.77, 0.16);
    ShardTracker_MoneyToggle();
    
    -- if we're not a warlock and this is a healthstone, show a different tooltip
    if (UnitClass("player") ~= SHARDTRACKER_WARLOCK and theText1 == SHARDTRACKER_HEALTHBUTTON_TIP1) then
        ShardTracker_MoneyToggle();
        GameTooltip:AddLine(SHARDTRACKER_HEALTHBUTTON_TIP5, 0.82, 0.24, 0.79);
        ShardTracker_MoneyToggle();
    else
    
        -- add status lines to the tooltip
        if (theText1 == SHARDTRACKER_SHARDBUTTON_TIP1) then
            if (ShardTracker_TotalShards > 0) then
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_SHARDBUTTON_STATUS1.." "..SHARDTRACKER_BUTTON_CTRLCLICKTEXT, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            end
        elseif (theText1 == SHARDTRACKER_HEALTHBUTTON_TIP1) then
            local MUTE_TEXT = "";
            if (SHARDTRACKER_CONFIG.NAGHEALTH) then
                MUTE_TEXT = SHARDTRACKER_BUTTON_SHIFTCLICKTEXT1..SHARDTRACKER_BUTTON_SHIFTCLICKTEXT3;
            else
                MUTE_TEXT = SHARDTRACKER_BUTTON_SHIFTCLICKTEXT1..SHARDTRACKER_BUTTON_SHIFTCLICKTEXT2..SHARDTRACKER_BUTTON_SHIFTCLICKTEXT3;
            end
            if (ShardTracker_HaveHealthStone == 1) then
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_HEALTHBUTTON_STATUS1.." "..MUTE_TEXT, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            else
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_HEALTHBUTTON_STATUS2.." "..MUTE_TEXT, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            end
        elseif (theText1 == SHARDTRACKER_SOULBUTTON_TIP1) then    
            local MUTE_TEXT = "";
            if (SHARDTRACKER_CONFIG.NAGSOUL) then
                MUTE_TEXT = SHARDTRACKER_BUTTON_SHIFTCLICKTEXT1..SHARDTRACKER_BUTTON_SHIFTCLICKTEXT3;
            else
                MUTE_TEXT = SHARDTRACKER_BUTTON_SHIFTCLICKTEXT1..SHARDTRACKER_BUTTON_SHIFTCLICKTEXT2..SHARDTRACKER_BUTTON_SHIFTCLICKTEXT3;
            end
            if (ShardTracker_HaveSoulStone == 1 and ShardTracker_SoulStoneExpired == 1) then
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_SOULBUTTON_STATUS1.." "..SHARDTRACKER_BUTTON_CTRLCLICKTEXT.." "..MUTE_TEXT, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            elseif (ShardTracker_HaveSoulStone == 1) then
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_SOULBUTTON_STATUS2.." "..SHARDTRACKER_BUTTON_CTRLCLICKTEXT.." "..MUTE_TEXT, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            else
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_SOULBUTTON_STATUS3.." "..SHARDTRACKER_BUTTON_CTRLCLICKTEXT.." "..MUTE_TEXT, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            end
        elseif (theText1 == SHARDTRACKER_SPELLBUTTON_TIP1) then
            if (ShardTracker_SpellStoneReady == 1 and ShardTracker_SpellStoneEquipped == 1) then
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_SPELLBUTTON_STATUS1.." "..SHARDTRACKER_BUTTON_CTRLCLICKTEXT, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            elseif (ShardTracker_SpellStoneEquipped == 1) then
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_SPELLBUTTON_STATUS2.." "..SHARDTRACKER_BUTTON_CTRLCLICKTEXT, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            elseif (ShardTracker_SpellStoneInBag == 1) then
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_SPELLBUTTON_STATUS3.." "..SHARDTRACKER_BUTTON_CTRLCLICKTEXT, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            else
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_SPELLBUTTON_STATUS4.." "..SHARDTRACKER_BUTTON_CTRLCLICKTEXT, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            end
        elseif (theText1 == SHARDTRACKER_FIREBUTTON_TIP1) then
            if (ShardTracker_FireStoneInBag == 1) then
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_FIREBUTTON_STATUS1, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            elseif (ShardTracker_FireStoneEquipped == 1) then
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_FIREBUTTON_STATUS2, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            else
                ShardTracker_MoneyToggle();
                GameTooltip:AddLine(SHARDTRACKER_FIREBUTTON_STATUS3, 0.39, 0.77, 0.16);
                ShardTracker_MoneyToggle();     
            end
        end
    
        -- add description lines to the tooltip
        if (theText2) then
            ShardTracker_MoneyToggle();
            GameTooltip:AddLine(theText2, 0.82, 0.24, 0.79);
            ShardTracker_MoneyToggle();
        end
        if (theText3) then
            ShardTracker_MoneyToggle();
            GameTooltip:AddLine(theText3, 0.82, 0.24, 0.79);
            ShardTracker_MoneyToggle();
        end
        if (theText4) then
            ShardTracker_MoneyToggle();
            GameTooltip:AddLine(theText4, 0.82, 0.24, 0.79);
            ShardTracker_MoneyToggle();
        end
        if (theText5) then
            ShardTracker_MoneyToggle();
            GameTooltip:AddLine(theText5, 0.82, 0.24, 0.79);
            ShardTracker_MoneyToggle();
        end
    end
    
    -- Adjust width and height to account for new lines and show the tooltip
    -- (the Show() command automatically adjusts the width/height)
    GameTooltip:Show();

end


-----------------------------------------------------------------------------------
--
-- Hide the help tooltip for a minimap button
--
-----------------------------------------------------------------------------------
function ShardTracker_HideButtonTooltip()
    GameTooltip:Hide();
    if (ColorCycle_Exists) then
        ColorCycle_Remove("ShardTrackerHelpToolTipTitle");    
    end
end


-----------------------------------------------------------------------------------
--
-- Set the scale of the shardtracker buttons
--
-----------------------------------------------------------------------------------
function ShardTracker_SetButtonScale(scaleName, slashCmd)
    local theScale;
    theScale = 0;
    
    if (scaleName == "" or scaleName == SHARDTRACKER_SCALE_1_CMD) then
        theScale = SHARDTRACKER_SCALE_1;
        SHARDTRACKER_CONFIG.BUTTONSCALE = SHARDTRACKER_SCALE_1_CMD;
        if (slashCmd) then ShardTrackerPrint(ST_SCALECHANGE..SHARDTRACKER_SCALE_1_CMD.."."); end
    elseif (scaleName == SHARDTRACKER_SCALE_2_CMD) then
        theScale = SHARDTRACKER_SCALE_2;
        SHARDTRACKER_CONFIG.BUTTONSCALE = SHARDTRACKER_SCALE_2_CMD;
        if (slashCmd) then ShardTrackerPrint(ST_SCALECHANGE..SHARDTRACKER_SCALE_2_CMD.."."); end
    elseif (scaleName == SHARDTRACKER_SCALE_3_CMD) then
        theScale = SHARDTRACKER_SCALE_3;
        SHARDTRACKER_CONFIG.BUTTONSCALE = SHARDTRACKER_SCALE_3_CMD;
        if (slashCmd) then ShardTrackerPrint(ST_SCALECHANGE..SHARDTRACKER_SCALE_3_CMD.."."); end
    elseif (scaleName == SHARDTRACKER_SCALE_4_CMD) then
        theScale = SHARDTRACKER_SCALE_4;
        SHARDTRACKER_CONFIG.BUTTONSCALE = SHARDTRACKER_SCALE_4_CMD;
        if (slashCmd) then ShardTrackerPrint(ST_SCALECHANGE..SHARDTRACKER_SCALE_4_CMD.."."); end
    elseif (scaleName == "debug") then
        ShardTrackerDebug("SHARDTRACKER_SCALE_1 = "..SHARDTRACKER_SCALE_1.."Minimap:GetScale() = "..Minimap:GetScale().." ShardTracker_ShardButton:GetScale() = "..ShardTracker_ShardButton:GetScale());
    else
        ShardTrackerPrint(ST_SCALEUSAGE..SHARDTRACKER_SCALE_1_CMD.."|"..SHARDTRACKER_SCALE_2_CMD.."|"..SHARDTRACKER_SCALE_3_CMD.."|"..SHARDTRACKER_SCALE_4_CMD);        
    end
    
    if (theScale ~= 0) then
        ShardTrackerDebug("Scale set to: "..theScale);

        -- set the scales
        ShardTracker_ShardButton:SetScale(theScale);
        ShardTracker_HealthStoneButton:SetScale(theScale);
        ShardTracker_SoulStoneButton:SetScale(theScale);
        ShardTracker_SpellStoneButton:SetScale(theScale);
        ShardTracker_FireStoneButton:SetScale(theScale);
        
        ShardTracker_ButtonSetLocation();
    end
end



-----------------------------------------------------------------------------------
--
-- Return the numerical value of a button scale name ("regular," "biggie," etc)
--
-----------------------------------------------------------------------------------
function ShardTracker_GetButtonScaleValue(scaleName)
    if (scaleName == SHARDTRACKER_SCALE_1_CMD) then
        return SHARDTRACKER_SCALE_1;
    elseif (scaleName == SHARDTRACKER_SCALE_2_CMD) then
        return SHARDTRACKER_SCALE_2;
    elseif (scaleName == SHARDTRACKER_SCALE_3_CMD) then
        return SHARDTRACKER_SCALE_3;
    elseif (scaleName == SHARDTRACKER_SCALE_4_CMD) then
        return SHARDTRACKER_SCALE_4;
    else
        return 0;
    end
end


-----------------------------------------------------------------------------------
--
-- Initialize the scale of the shardtracker buttons
--
-----------------------------------------------------------------------------------
function ShardTracker_InitButtonScales()

    ShardTrackerTron("ShardTracker_InitButtonScales");
    
    -- determine the scales based on our resolution
    SHARDTRACKER_BASESCALE = Minimap:GetScale();
    SHARDTRACKER_SCALE_1  = SHARDTRACKER_BASESCALE
    SHARDTRACKER_SCALE_2  = SHARDTRACKER_BASESCALE * 1.25;
    SHARDTRACKER_SCALE_3  = SHARDTRACKER_BASESCALE * 1.5;
    SHARDTRACKER_SCALE_4  = SHARDTRACKER_BASESCALE * 1.75;

    ShardTrackerDebug("SHARDTRACKER_SCALE_1 = "..SHARDTRACKER_SCALE_1.." Minimap:GetScale() = "..Minimap:GetScale().." ShardTracker_ShardButton:GetScale() = "..ShardTracker_ShardButton:GetScale());
    
    -- set the button scales    
    ShardTracker_SetButtonScale(SHARDTRACKER_CONFIG.BUTTONSCALE);
end

-----------------------------------------------------------------------------------
--
-- Show the "soulstone ready" alerts
--
-----------------------------------------------------------------------------------
function ShardTracker_NotifySoulstoneReady()
    if (SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP == 1 or SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP == true) then
        ShardTrackerSortText:SetText(SHARDTRACKER_SOULSTONEREADYMSG);
        ShardTrackerSortText:SetTextColor(1.0,0.0,0.0);
        ShardTrackerSortFrame:SetAlpha(1.0);
        ShardTrackerSortFrame:Show();
        UIFrameFadeOut(ShardTrackerSortFrame, 5);
    end
    ShardTracker_StartNotificationSound(SHARDTRACKER_SOULSTONE);
    ShardTrackerPrint(SHARDTRACKER_SSREADYTOCAST,1.0,0.0,0.0);
end


---------------------------------------------------------------------------------
--
-- Color Selection Interface Functions
--
---------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
-- When the user clicks to set the text color of a button
-----------------------------------------------------------------------------------
function ShardTracker_SelectButtonTextColor(theButton)

    if (theButton == "shard") then
        ShardTracker_ColorPicker(ShardTracker_ColorPickerShard_OnUpdate, 
                                 SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[1], 
                                 SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[2],
                                 SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[3],
                                 ShardTracker_ColorPickerShardCancelButton);
    elseif (theButton == "soul") then
        ShardTracker_ColorPicker(ShardTracker_ColorPickerSoul_OnUpdate, 
                                 SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[1], 
                                 SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[2],
                                 SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[3],
                                 ShardTracker_ColorPickerSoulCancelButton);
    elseif (theButton == "spell") then
        ShardTracker_ColorPicker(ShardTracker_ColorPickerSpell_OnUpdate, 
                                 SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[1], 
                                 SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[2],
                                 SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[3],
                                 ShardTracker_ColorPickerSpellCancelButton);
    end
end

---------------------------------------------------------------------------------
-- Start the color picking process
---------------------------------------------------------------------------------
function ShardTracker_ColorPicker(func, rval, gval, bval, cancelFunc)    
    ColorPickerFrame.func = func;
    ColorPickerFrame:SetColorRGB(rval, gval, bval);
    ColorPickerFrame.previousValues = {r = rval, g = gval, b = bval};
    ColorPickerFrame.cancelFunc = cancelFunc;
    ShowUIPanel(ColorPickerFrame);
end

---------------------------------------------------------------------------------
-- Update colors to reflect the currently selected color
---------------------------------------------------------------------------------
function ShardTracker_ColorPickerShard_OnUpdate()
    local rval, gval, bval = ColorPickerFrame:GetColorRGB();
    SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[1] = rval;
    SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[2] = gval;
    SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[3] = bval;
    ShardTrackerText:SetTextColor(rval, gval, bval);
end

---------------------------------------------------------------------------------
-- Abort color picking and reset the colors to their previous values
---------------------------------------------------------------------------------
function ShardTracker_ColorPickerShardCancelButton()
    SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[1] = ColorPickerFrame.previousValues.r;
    SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[2] = ColorPickerFrame.previousValues.g;
    SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[3] = ColorPickerFrame.previousValues.b;
    ShardTrackerText:SetTextColor(ColorPickerFrame.previousValues.r, 
                                  ColorPickerFrame.previousValues.g, 
                                  ColorPickerFrame.previousValues.b);
end

---------------------------------------------------------------------------------
-- Update colors to reflect the currently selected color
---------------------------------------------------------------------------------
function ShardTracker_ColorPickerSoul_OnUpdate()
    local rval, gval, bval = ColorPickerFrame:GetColorRGB();
    SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[1] = rval;
    SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[2] = gval;
    SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[3] = bval;
    ShardTrackerSoulText:SetTextColor(rval, gval, bval);
end

---------------------------------------------------------------------------------
-- Abort color picking and reset the colors to their previous values
---------------------------------------------------------------------------------
function ShardTracker_ColorPickerSoulCancelButton()
    SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[1] = ColorPickerFrame.previousValues.r;
    SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[2] = ColorPickerFrame.previousValues.g;
    SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[3] = ColorPickerFrame.previousValues.b;
    ShardTrackerSoulText:SetTextColor(ColorPickerFrame.previousValues.r, 
                                      ColorPickerFrame.previousValues.g, 
                                      ColorPickerFrame.previousValues.b);
end

---------------------------------------------------------------------------------
-- Update colors to reflect the currently selected color
---------------------------------------------------------------------------------
function ShardTracker_ColorPickerSpell_OnUpdate()
    local rval, gval, bval = ColorPickerFrame:GetColorRGB();
    SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[1] = rval;
    SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[2] = gval;
    SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[3] = bval;
    ShardTrackerSpellText:SetTextColor(rval, gval, bval);
end

---------------------------------------------------------------------------------
-- Abort color picking and reset the colors to their previous values
---------------------------------------------------------------------------------
function ShardTracker_ColorPickerSpellCancelButton()
    SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[1] = ColorPickerFrame.previousValues.r;
    SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[2] = ColorPickerFrame.previousValues.g;
    SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[3] = ColorPickerFrame.previousValues.b;
    ShardTrackerSpellText:SetTextColor(ColorPickerFrame.previousValues.r, 
                                       ColorPickerFrame.previousValues.g, 
                                       ColorPickerFrame.previousValues.b);
end



--============================================================================================--
--============================================================================================--
--                                                                                            --
--                      COLORCYCLE EFFECT FUNCTIONS                                           --
--                                                                                            --
--============================================================================================--
--============================================================================================--


---------------------------------------------------------------------------------
-- Check to see if any aura changes are relevant to us
---------------------------------------------------------------------------------
function ShardTracker_CheckAuraChange()
    -- check our buffs for certain auras
    local foundNightfall = false;
    local foundShield = false;
    for i = 1, 16 do
        local texture = UnitBuff("player", i);
        if (texture) then        
            --Print("AuraTexture = "..texture);
            if (string.find(texture, "Shadow_Twilight")) then              
                foundNightfall = true;
                break;
            elseif (string.find(texture, "Spell_Shadow_SacrificialShield")) then   
                foundShield = true;
            end
        end
    end
    
    -- apply the nightfall effect
    if (SHARDTRACKER_CONFIG.NIGHTFALLEFFECT or (not foundNightfall and ShardTracker_NightfallAuraActive)) then
        if (foundNightfall) then
            if (not ShardTracker_NightfallAuraActive) then
                ShardTracker_NightfallAuraActive = true;
                ShardTracker_ToggleNightfallVisuals(true);
            end
        else
            if (ShardTracker_NightfallAuraActive) then
                ShardTracker_NightfallAuraActive = false;
                ShardTracker_ToggleNightfallVisuals(false);
            end
        end
    end   
--[[    
    if (foundShield) then
        if (not ShardTracker_ShieldStatusBarActive) then
            ShardTracker_ShieldStatusBarActive = true;
            ShardTracker_ToggleShieldStatusBar(true);
        end
    else
        if (ShardTracker_ShieldStatusBarActive) then
            ShardTracker_ShieldStatusBarActive = false;
            ShardTracker_ToggleShieldStatusBar(false);
        end
    end
]]--
end


---------------------------------------------------------------------------------
-- Trigger the created-a-shard visual
---------------------------------------------------------------------------------
function ShardTracker_TriggerCreatedSoulShardVisual()
    if (SHARDTRACKER_CONFIG.SHARDEFFECT) then
        if (ColorCycle_Exists) then
            ColorCycle_ColorFlashScreen("SoulShard Created Effect", 1.0, 0.31, 1.0, 0.4);        
        end 
    end
end



---------------------------------------------------------------------------------
-- Cleanup stuff once the got-a-shard visual has finished
---------------------------------------------------------------------------------
function ShardTracker_TriggerCreatedSoulShardVisual_Cleanup()
    ShardTrackerSoulShardFillScreenFrame:Hide();
    ColorCycle_Remove("SoulShard Created");
end


---------------------------------------------------------------------------------
-- Toggle the nightfall visuals
---------------------------------------------------------------------------------
function ShardTracker_ToggleNightfallVisuals(toggle)
    if (ColorCycle_Exists) then
        if (toggle) then    
        
            -- make the casting bar glow purple and white
            ColorCycle_FlashWhite(
                {
                    ID              = "Shardtracker Nightfall Casting Bar";
                    globalType      = "StatusBar";
                    globalName      = "CastingBarFrameStatusBar";
                    colorStart      = {0.82, 0.24, 0.79};
                }
            );
            
            -- make the casting bar text fade from white to black
            ColorCycle_Add(
                {
                    ID              = "Shardtracker Nightfall Casting Bar Text";
                    globalType      = "FontText";
                    globalName      = "CastingBarText";
                    colorStart      = "white";
                    colorEnd        = "black";
                    doneCondition   = "black";
                    speed           = 0.01;
                    whenDone        = "end";
                }
            );
            
            -- make the screen go dark, then glow purple
            ColorCycle_Add( 
                {
                    ID              = "Shardtracker Nightfall Screen Tint";
                    globalType      = "Texture";
                    globalName      = "ShardTrackerNightfallFillScreenTexture";
                    colorStart      = {0.0, 0.0, 0.0, 0.0};
                    colorEnd        = {0.0, 0.0, 0.0, 1.0};
                    alphaBounds     = {0.0, 1.0};
                    alphaSpeed      = 0.03;
                    alphaMode       = "once";
                    doneCondition   = {0.0, 0.0, 0.0, 1.0};
                    unique          = false;
                }
            );
            ColorCycle_PulseColor( 
                {
                    ID              = "Shardtracker Nightfall Screen Tint";
                    globalType      = "Texture";
                    globalName      = "ShardTrackerNightfallFillScreenTexture";
                    colorStart      = {0.0, 0.0, 0.0};
                    colorEnd        = {0.24, 0.08, 0.37};
                    pause           = 0.5;
                    pauseWhere      = "lower";
                    speed           = 0.03;
                    unique          = false;
                }
            );
            ShardTrackerNightfallFillScreenFrame:SetFrameLevel(1);
            ShardTrackerNightfallFillScreenFrame:SetAlpha(0.5);
            ShardTrackerNightfallFillScreenFrame:Show();
            
        -- else nightfall is done, so fade back up to normalness and cleanup
        else
            ColorCycle_Remove("Shardtracker Nightfall Casting Bar");
            ColorCycle_Remove("Shardtracker Nightfall Main Menu", true);
            ColorCycle_Remove("Shardtracker Nightfall Screen Tint", true);
            ColorCycle_Add( 
                {
                    ID              = "Shardtracker Nightfall Fade Back Up";
                    globalType      = "Texture";
                    globalName      = "ShardTrackerNightfallFillScreenTexture";
                    colorStart      = {0.0, 0.0, 0.0, 1.0};
                    colorEnd        = {0.0, 0.0, 0.0, 0.0};
                    alphaBounds     = {0.0, 1.0};
                    alphaSpeed      = 0.03;
                    alphaMode       = "once";
                    doneCondition   = {0.0, 0.0, 0.0, 0.0};
                    whenDone        = "end";
                    endingFunction  = {ShardTracker_NightfallDoneCleanup};
                    unique          = false;
                }
            );
            -- make the casting bar text fade from black to white
            ColorCycle_Add(
                {
                    ID              = "Shardtracker Nightfall Casting Bar Text";
                    globalType      = "FontText";
                    globalName      = "CastingBarText";
                    colorStart      = "black";
                    colorEnd        = "white";
                    doneCondition   = "white";
                    speed           = 0.01;
                    whenDone        = "end";
                }
            );
            
            CastingBarFrameStatusBar:SetStatusBarColor(1.0, 0.7, 0.0);
        end
    end
end


---------------------------------------------------------------------------------
-- Cleanup the nightfall visuals when nightfall is over
---------------------------------------------------------------------------------
function ShardTracker_NightfallDoneCleanup()
    ShardTrackerNightfallFillScreenFrame:Hide();
    ColorCycle_Remove("Shardtracker Nightfall Fade Away", true);
end


function ShardTracker_ToggleShieldStatusBar(toggle)
    if (toggle) then
        ShardTrackerShieldTimerBarFrameStatusBar:SetStatusBarColor(1.0, 0.7, 0.0);
        ShardTrackerShieldTimerBarFrame.startTime = GetTime();
        Print("startTime = "..ShardTrackerShieldTimerBarFrame.startTime);
        ShardTrackerShieldTimerBarFrame.maxValue = ShardTrackerShieldTimerBarFrame.startTime + 15;
        Print("maxValue = "..ShardTrackerShieldTimerBarFrame.maxValue);
        ShardTrackerShieldTimerBarFrameStatusBar:SetMinMaxValues(ShardTrackerShieldTimerBarFrame.startTime, ShardTrackerShieldTimerBarFrame.maxValue);
        ShardTrackerShieldTimerBarFrameStatusBar:SetValue(ShardTrackerShieldTimerBarFrame.maxValue);
        ShardTrackerShieldTimerBarFrameCastingBarText:SetText("Shield Time");
        ShardTrackerShieldTimerBarFrame:SetAlpha(1.0);
        ShardTrackerShieldTimerBarFrame:Show();
    else
        ShardTrackerShieldTimerBarFrame:Hide();
    end
end

function ShardTracker_StatusBar_OnLoad()
end

function ShardTracker_StatusBar_OnEvent()
end

function ShardTracker_StatusBar_OnUpdate()
    local status = ShardTrackerShieldTimerBarFrame.maxValue - (GetTime() - ShardTrackerShieldTimerBarFrame.startTime);
    if (status < ShardTrackerShieldTimerBarFrame.startTime) then
        status = ShardTrackerShieldTimerBarFrame.startTime;
    end
    ShardTrackerShieldTimerBarFrameStatusBar:SetValue(status);
end

--[[

start 10
gettime 21

end 20

function ShardTracker_InitStatusbar()
    CastingBarFrameStatusBar:SetStatusBarColor(1.0, 0.7, 0.0);
    CastingBarSpark:Show();
    this.startTime = GetTime();
    this.maxValue = this.startTime + (arg2 / 1000);
    CastingBarFrameStatusBar:SetMinMaxValues(this.startTime, this.maxValue);
    CastingBarFrameStatusBar:SetValue(this.startTime);
    CastingBarText:SetText(arg1);
    this:SetAlpha(1.0);
    this.holdTime = 0;
    this.casting = 1;
    this.fadeOut = nil;
    this:Show();
end


function ShardTracker_UpdateStatusBar()
    local status = GetTime();
    if ( status > this.maxValue ) then
        status = this.maxValue
    end
    CastingBarFrameStatusBar:SetValue(status);
    CastingBarFlash:Hide();
    local sparkPosition = ((status - this.startTime) / (this.maxValue - this.startTime)) * 195;
    if ( sparkPosition < 0 ) then
        sparkPosition = 0;
    end
    CastingBarSpark:SetPoint("CENTER", "CastingBarFrameStatusBar", "LEFT", sparkPosition, 0);
end
]]--