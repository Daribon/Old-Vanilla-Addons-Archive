
-- Class definition
AceDataClass = AceDbClass:new("AceDB")

-- Need a constructor to override the AceDB one.
function AceDataClass:new()
    return ace:new(self)
end

function AceDataClass:Initialize()
    if( self.initialized ) then return end

    self.optionsPath     = {"options"}
    self.profileBasePath = {"profiles"}
    self.profileMapPath  = {"profileMap"}

    return AceDbClass.Initialize(self)
end


--[[---------------------------------------------------------------------------------
  Ace Settings
------------------------------------------------------------------------------------]]

function AceDataClass:GetOpt(var)
    return self:get(self.optionsPath, var)
end

function AceDataClass:SetOpt(var, val)
    return self:set(self.optionsPath, var, val)
end


--[[---------------------------------------------------------------------------------
  Profile Management
------------------------------------------------------------------------------------]]

function AceDataClass:GetAddonProfile(profile, addon, addprof)
    return self:get({self.profileBasePath, profile}, addon.name, addprof)
end

function AceDataClass:SetAddonProfile(profile, addon, addprof)
    if( not addon ) then return end

    self:set({self.profileBasePath, profile}, addon.name, addprof)
    if( addprof and (not addon.db:get(self.profileBasePath, profile)) ) then
        local defaults = self:GetAddonDefaults(addon)
        if( defaults ) then
            addon.db:set(self.profileBasePath, profile, defaults)
        end
    end
end

function AceDataClass:LoadCurrentProfile()
    local profile = self:get(self.profileMapPath, ace.char.id)
    if( (not profile) or (not self:GetProfile(profile)) ) then
        profile = ACE_PROFILE_DEFAULT
    end

    self:LoadProfile(profile)
end

function AceDataClass:LoadProfile(name)
    self.profileName = name
    self.profilePath = {self.profileBasePath, name}
    self:set(self.profileMapPath, ace.char.id, name)
    local _, addon
    for _, addon in ace.registry:get() do
        if( addon.db and addon.db.initialized ) then
            addon.profilePath = {self.profileBasePath, self:LoadAddonProfile(name, addon)}
            if( addon.ProfileUpdate ) then addon.ProfileUpdate(self) end
        end
    end
end

function AceDataClass:GetProfile(name)
    return self:get(self.profileBasePath, name)
end

function AceDataClass:LoadAddonProfile(name, addon)
    local profile = self:get({self.profileBasePath, name}, addon.name) or name
    if( addon.db:get(self.profileBasePath, profile) ) then return profile end

    local defaults = self:GetAddonDefaults(addon)
    profile        = ACE_PROFILE_DEFAULT

    if( defaults and (not addon.db:get(self.profileBasePath, profile)) ) then
        addon.db:set(self.profileBasePath, profile, defaults)
    end

    return profile
end

function AceDataClass:GetAddonDefaults(addon)
    if( addon.db:get(self.profileBasePath, "default") ) then
        return ace.CopyTable({}, addon.db:get(self.profileBasePath, ACE_PROFILE_DEFAULT))
    elseif( addon.defaults ) then
        return ace.CopyTable({}, addon.defaults)
    end
end

function AceDataClass:SaveProfile(name, profile)
    self:set(self.profileBasePath, name, {desc=profile.desc})
    if( not profile.addons ) then return end
    local _, addon
    for _, addon in ace.registry:get() do
        if( addon.db and profile.addons[addon.name] ) then
            addon.db:set(self.profileBasePath, name, profile.addons[addon.name])
        end
    end
end

function AceDataClass:DeleteProfile(name)
    self:set(self.profileBasePath, name)
    local _, addon
    for _, addon in ace.registry:get() do
        if( addon.db ) then
            addon.db:set(self.profileBasePath, name)
        end
    end
end

function AceDataClass:NewProfile(incDefaults)
    local profile, _, addon = {}
    if( not incDefault ) then return profile end

    profile.addons = {}
    for _, addon in ace.registry:get() do
        if( addon.db and incDefaults ) then
            profile.addons[addon.name] = self:GetAddonDefaults(addon)
        end
    end
    return profile
end

ace.db = AceDataClass:new()
