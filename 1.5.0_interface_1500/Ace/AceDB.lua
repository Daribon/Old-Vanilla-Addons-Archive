
local ACE_DB_TIMESTAMP_FMT = "%Y%m%d%H%M%S"

-- Class definition
AceDbClass = AceCoreClass:new()

-- Object constructor
function AceDbClass:new(val, seed)
    o = ace:new(self, {seed=seed})
    if( type(val)=="string" ) then
        o.name = val
    else
        o._table = val or {}
        o.initialized = TRUE
    end
    return o
end

function AceDbClass:Initialize()
    if( self.initialized ) then return end
    self.initialized = TRUE

    self._table = getglobal(self.name)
    if( self._table ) then return end

    self._table = {}
    setglobal(self.name, self._table)
    if( self.seed ) then
        ace.CopyTable(self._table, self.seed)
    end
    self.created = TRUE

    return self.created
end

function AceDbClass:_DelvePath(node, path)
    local _, val, key, parent
    for _, val in ipairs(path) do
        parent = node
        key    = val
        if( type(val)=="table" ) then
            node, parent, key = self:_DelvePath(node, val)
            if( not node ) then return end
        elseif( not node[val] ) then
            -- If we're not creating the path and the node doesn't exist, we're done.
            if( not self.create ) then return end
            node[val] = {}
            node = node[val]
        else
            node = node[val]
        end
    end
    return node, parent, key
end

function AceDbClass:_GetNode(path, create)
    if( not path ) then return self._table end
    self.create = create
    local node, parent, key = self:_DelvePath(self._table, path)
    self.create = FALSE
    return node, parent, key
end

function AceDbClass:_GetArgs(arg)
    if( type(arg[1]) == "table" ) then
        return arg[1], arg[2], arg[3]
    end
    return nil, arg[1], arg[2]
end

function AceDbClass:get(...)
    if( getn(arg) < 1 ) then return self._table end
    local path, key = self:_GetArgs(arg)
    return (self:_GetNode(path) or {})[key]
end

function AceDbClass:set(...)
    local path, key, val = self:_GetArgs(arg)
    local node = self:_GetNode(path, TRUE)
    node[key] = val
    return node[key]
end

function AceDbClass:toggle(...)
    local path, key = self:_GetArgs(arg)
    local node = self:_GetNode(path, TRUE)
    node[key]  = ace.toggle(node[key])
    return node[key]
end

function AceDbClass:insert(...)
    local path, key, val = self:_GetArgs(arg)
    local node = self:_GetNode(path, TRUE)
    tinsert(node[key], val)
end

function AceDbClass:remove(...)
    local path, key, val = self:_GetArgs(arg)
    local node = self:_GetNode(path, TRUE)
    return tremove(node[key])
end

function AceDbClass:reset(path, seed)
    if( path ) then
        local _, parent, key = self:_GetNode(path)
        if( (not parent) or (not key) ) then return end
        parent[key] = {}
        if( seed ) then ace.CopyTable(parent[key], seed) end
        return parent[key]
    else
        self._table = {}
        if( self.name ) then setglobal(self.name, self._table) end
        if( seed or self.seed ) then
            ace.CopyTable(self._table, seed or self.seed)
        end
        return self._table
    end
end

function AceDbClass:timestamp()
    return date(ACE_DB_TIMESTAMP_FMT)
end
