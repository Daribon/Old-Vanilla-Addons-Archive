
-- Class definition
AceCommandsClass = AceChatCmdClass:new()


--[[--------------------------------------------------------------------------
  Ace Information
-----------------------------------------------------------------------------]]

function AceCommandsClass:DisplayInfo()
    local disabledMsg = ""
    local mismatchMsg = ""

    if( ace.disabledCnt > 0 ) then
        disabledMsg = format(ACE_LOAD_MSG_DISABLED, ace.disabledCnt)
    end
    if( ace.mismatchCnt > 0 ) then
        mismatchMsg = format(ACE_INFO_MISMATCH, ace.mismatchCnt)
    end
    self:report(ACE_INFO_HEADER..mismatchMsg, {
        {text=ACE_INFO_PROFILE_LOADED, val=ace.db.profileName},
        {text=ACE_INFO_NUM_ADDONS,     val=ace.addonCnt..disabledMsg},
    })
end


--[[--------------------------------------------------------------------------
  Configurations
-----------------------------------------------------------------------------]]

function AceCommandsClass:ChangeLoadMsgAddon()
    ace.db:SetOpt("loadMsg", "addon")
    self:result(ACE_CMD_LOADMSG_ADDON)
end

function AceCommandsClass:ChangeLoadMsgNone()
    ace.db:SetOpt("loadMsg", "none")
    self:result(ACE_CMD_LOADMSG_NONE)
end

function AceCommandsClass:ChangeLoadMsgSum()
    ace.db:SetOpt("loadMsg")
    self:result(ACE_CMD_LOADMSG_SUM)
end


--[[--------------------------------------------------------------------------
  Profile Options
-----------------------------------------------------------------------------]]

function AceCommandsClass:SetProfile(profile, key, msg)
    self:LoadProfile(profile, msg)

    if( (key or "") ~= "" ) then
        if( strlower(key) == ACE_CMD_PROFILE_ALL ) then
            local _, addon
            for _, addon in ace.registry:get() do
                if( addon.db and (not ace.db:GetAddonProfile(profile, addon, profile)) ) then
                    ace.db:SetAddonProfile(profile, addon, profile)
                end
            end
        else
            local _, addon = ace.TableFindKeyCaseless(ace.registry:get(), key)
            if( not addon ) then
                self:result(format(ACE_CMD_PROFILE_NO_ADDON, key))
                return
            end
            if( not addon.db ) then
                self:result(format(ACE_CMD_PROFILE_NO_PROFILE, addon.name))
            end
            ace.db:SetAddonProfile(profile, addon, profile)
            self:result(format(ACE_CMD_PROFILE_ADDON_ADDED, addon.name, profile))
        end
    end
end

function AceCommandsClass:LoadProfile(profile, msg)
    if( ace.db:GetProfile(profile) ) then
        ace.db:LoadProfile(profile)
    else
        ace.db:SaveProfile(profile, ace.db:NewProfile())
        ace.db:LoadProfile(profile)
    end
    if( msg ) then self:result(msg) end
end

function AceCommandsClass:UseProfileChar(addon)
    self:SetProfile(ace.char.id, addon, format(ACE_PROFILE_LOADED_CHAR, ace.char.id))
end

function AceCommandsClass:UseProfileClass(addon)
    self:SetProfile(ace.char.class, addon,
                    format(ACE_PROFILE_LOADED_CLASS, ace.char.class, ace.char.id)
                   )
end

function AceCommandsClass:UseProfileDefault()
    ace.db:LoadProfile(ACE_PROFILE_DEFAULT)
    self:result(format(ACE_PROFILE_LOADED_DEFAULT, ace.char.id))
end


ace.cmd = AceCommandsClass:new(ACE_COMMANDS, ACE_CMD_OPTIONS)
ace.cmd.addon = ace

