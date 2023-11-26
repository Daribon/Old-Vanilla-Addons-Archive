
KC_ItemsModuleClass = AceModuleClass:new();


-- KCI Central DB Closures

function KC_ItemsModuleClass:KCIGetOpt(var, path)
	return self.app:GetOpt(var, path)
end

function KC_ItemsModuleClass:KCISetOpt(var, val, path)
	return self.app:SetOpt(var, val, path)
end

function KC_ItemsModuleClass:KCITogOpt(var, path)
	return self.app:TogOpt(var, path)
end


-- Module DB Closures. These use the addon's (KC_Items's) profilePath to ensure
-- that the proper profile will always get used.

function KC_ItemsModuleClass:GetOpt(var, path)
	if (self.db) then
		local profilePath = self.app.profilePath;
		
		if (path) then
			profilePath = {profilePath, path};
		end
		
		return self.db:get(profilePath, var)
	else
		return self.app:GetOpt(var, path)		
	end
	
end

function KC_ItemsModuleClass:SetOpt(var, val, path)
	if (self.db) then
		local profilePath = self.app.profilePath;
		
		if (path) then
			profilePath = {profilePath, path};
		end
		
		return self.db:set(profilePath, var, val)
	else
		return self.app:SetOpt(var, val, path)		
	end
end

function KC_ItemsModuleClass:TogOpt(var, path)
	if (self.db) then
		local profilePath = self.app.profilePath;
		
		if (path) then
			profilePath = {profilePath, path};
		end
		
		return self.db:toggle(profilePath, var)
	else
		return self.app:TogOpt(var, path)		
	end
end


-- Command Reporting Closures

function KC_ItemsModuleClass:Msg(...)
	self.app:Msg(unpack(arg))
end

function KC_ItemsModuleClass:Result(text, val, map)
	self.app:Result(text, val, map)
end

function KC_ItemsModuleClass:TogMsg(var, text)
	local val = self:TogOpt(var)
	self.app:Result(text, val, ACEG_MAP_ONOFF)
	return val
end

function KC_ItemsModuleClass:Error(...)
	self.app:Error(unpack(arg))
end


-- Enabling/Disabling

function KC_ItemsModuleClass:Register()
	self.disabled = TRUE
	self:RegisterEvent("KC_ITEMS_LOADED")
	self:RegisterEvent("KC_ITEMS_ENABLED")
end

function KC_ItemsModuleClass:KC_ITEMS_LOADED()
	self:debug("KC_Items Loaded")
	if( self.db ) then self.db:Initialize() end
end

function KC_ItemsModuleClass:KC_ITEMS_ENABLED()
	self:CheckEnable()
	self:RegisterEvent("KC_ITEMS_DISABLED")
	self:debug("KC_Items Enabled")
end

function KC_ItemsModuleClass:KC_ITEMS_DISABLED()
	self:Disable()
	self:debug("KC_Items Disabled")
end

function KC_ItemsModuleClass:KC_ITEMS_MODULE_ENABLED()
	if( self.disabled and self:CheckDependencies() ) then self:CheckEnable() end
end

function KC_ItemsModuleClass:KC_ITEMS_MODULE_DISABLED()
	if( self.disabled ) then return end
	if( not self:CheckDependencies() ) then self:Disable() end
end

function KC_ItemsModuleClass:CheckDependencies()
	if( not self.dependencies ) then return TRUE end

	local _, dep
	for _, dep in self.dependencies do
		if( (not self.app.modules[dep]) or
			(not self.app:ModEnabled(self.app.modules[dep]))
		) then
			return
		end
	end

	return TRUE
end

function KC_ItemsModuleClass:CheckEnable(force)
	if( (not self.app.disabled) and (self.app:ModEnabled(self) or force) and
		self:CheckDependencies()
	) then
		self:Enable()
		self.disabled = FALSE
--		self:TriggerEvent("KC_ITEMS_MODULE_ENABLED")
		self:RegisterEvent("KC_ITEMS_DISABLED")
		self:RegisterEvent("KC_ITEMS_MODULE_DISABLED")
		return TRUE
	end
end


-- Should be overridden
function KC_ItemsModuleClass:Enable() end

function KC_ItemsModuleClass:Disable()
	self:UnregisterAllEvents()
	self:UnhookAll()
	self.disabled = TRUE
	self:TriggerEvent("KC_ITEMS_MODULE_DISABLED")
	self:RegisterEvent("KC_ITEMS_ENABLED")
	self:RegisterEvent("KC_ITEMS_MODULE_ENABLED")
end


-- Common Module Command Handlers

function KC_ItemsModuleClass:Toggle()
	if( self.app:ModEnabled(self) ) then
		self.app:SetModState(self, FALSE)
		self:Disable()
		self:Result(self.name, nil, ACEG_MAP_ENABLED)
	elseif( self:CheckEnable(TRUE)) then
		self.app:SetModState(self, TRUE)
		self:Result(self.name, TRUE, ACEG_MAP_ENABLED)
	else
		self:Error(KC_ITEMS_ERR_MOD_ENABLE, self.name)
	end
end

-- Common KC_Item Functions

function KC_ItemsModuleClass:_id(link)
	return self.app:_id(link);
end

function KC_ItemsModuleClass:_code(link)
	return self.app:_code(link);
end

function KC_ItemsModuleClass:GetCode(link, sell, cost)
	return self.app:GetCode(link, sell, cost);
end

function KC_ItemsModuleClass:AddCode(code, sell, cost)
	return self.app:AddCode(code, sell, cost);
end

function KC_ItemsModuleClass:RemoveCode(code) 
	return self.app:RemoveCode(code);
end

function KC_ItemsModuleClass:GetID(link)
	return self.app:GetID(link);
end

-- Returns a valid items full name.
function KC_ItemsModuleClass:GetName(id, trunc)
	return self.app:GetName(id, trunc);
end

function KC_ItemsModuleClass:GetCodeByName(name)
	return self.app:GetCodeByName(name);
end

-- Returns a hyperlink for a valid item.  item:xxxxx:xxx:xxx:xxx
function KC_ItemsModuleClass:GetHyperlink(id)
	return self.app:GetHyperlink(id);
end

-- Returns a full textlink for a valid item.
function KC_ItemsModuleClass:GetTextLink(id)
	return self.app:GetTextLink(id);
end

-- Returns a numeric based quality value
function KC_ItemsModuleClass:GetQuality(id)
	return self.app:GetQuality(id);
end

-- Returns the minimal level of	an item.
function KC_ItemsModuleClass:GetMinLevel(id)
	return self.app:GetMinLevel(id);
end

-- Returns the item	type.  "Armor"
function KC_ItemsModuleClass:GetClass(id)
	return self.app:GetClass(id);
end

-- Returns the items subtype.  "Cloth"
function KC_ItemsModuleClass:GetSubClass(id)
	return self.app:GetSubClass(id);
end

-- Returns the max stack size.	"20"
function KC_ItemsModuleClass:GetMaxStackSize(id)
	return self.app:GetMaxStackSize(id);
end

-- Returns the 6 digit hex for a color.
function KC_ItemsModuleClass:GetColor(id)
	return self.app:GetColor(id);
end

-- Returns the 6 digit hex for a color.
function KC_ItemsModuleClass:GetQuality(id)
	return self.app:GetQuality(id);
end

-- Returns the wow Color code.
function KC_ItemsModuleClass:GetColorCode(id)
	return self.app:GetColorCode(id);
end

-- Returns the name	witht he corresponding color code prefixed.
function KC_ItemsModuleClass:GetColoredName(id, trunc)
	return self.app:GetColoredName(id, trunc);
end

-- returns a list of character ids.
function KC_ItemsModuleClass:GetCharList(realm, faction)
	return self.app:GetCharList(realm, faction);
end

function KC_ItemsModuleClass:GetItemPrices(code)
	return self.app:GetItemPrices(code);
end

function KC_ItemsModuleClass:SetItemPrices(code, sell, buy)
	return self.app:SetItemPrices(code, sell, buy);
end

function KC_ItemsModuleClass:GetStat(stat)
		return self.app:GetStat(stat);
end

-- Returns the 6 digit hex for a color.
function KC_ItemsModuleClass:GetLocation(id)
	return self.app:GetLocation(id);
end