--[[--------------------------------------------------------------------------------

  Ace

  Author:  Turan (turan@gryffon.com)
  Website: http://turan.gryffon.com/wow/ace

-----------------------------------------------------------------------------------]]


local ACE_VERSION       = "RC.1"
local ACE_COMP_VERSION  = "100"
local ACE_RELEASE       = "06-17-2005"
local ACE_WEBSITE       = "http://turan.gryffon.com/wow/ace"

TRUE  = 1
FALSE = nil


--[[--------------------------------------------------------------------------------
  Class Definition
-----------------------------------------------------------------------------------]]

-- AceCoreClass just provides a debug method for all Ace classes
AceCoreClass = {
    name        = ACE_NAME,
    description = ACE_DESCRIPTION,
    version     = ACE_VERSION
}

-- Object constructor
function AceCoreClass:new(t)
    local o = t or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function AceCoreClass:debug(...)
    if( ace.debugger ) then
        ace.debugger:Message((self.addon or {}).name or self.name or ACE_NAME, arg)
    end
end

-- The class for the main Ace object
AceClass = AceCoreClass:new({
    name        = ACE_NAME,
    version     = ACE_VERSION,
    website     = ACE_WEBSITE,
    addonCnt    = 0,
    disabledCnt = 0,
    mismatchCnt = 0
})

function AceClass:new(c,t)
    return AceCoreClass.new(c or self,t)
end


--[[--------------------------------------------------------------------------------
  Core Ace Methods
-----------------------------------------------------------------------------------]]

function AceClass:Compatability(v)
    return v - ACE_COMP_VERSION
end

function AceClass:call(obj, meth, ...)
    return function(...) return obj[meth](obj, unpack(arg)) end
end

function AceClass:print(...)
    local r,g,b,frame,delay
    if( type(arg[1]) == "table" ) then
        r,g,b,frame,delay = unpack(tremove(arg,1))
    end
    (frame or DEFAULT_CHAT_FRAME):AddMessage(self.concat(arg),r,g,b,1,delay or 5)
end

function AceClass:LoadTranslation(addon)
    local loader = getglobal(addon.."Locals_"..GetLocale())
    if( loader ) then loader(); return TRUE end
end

function AceClass:RegisterFunctions(class, utils)
    ace.state:RegisterFunctions(class ,utils)
end

function AceClass:RegisterGlobals(globals)
    ace.state:RegisterGlobals(globals)
end


--[[--------------------------------------------------------------------------------
  Core Utilities Used by Ace
-----------------------------------------------------------------------------------]]

function AceClass.ParseWords(str, pat)
    if( ace.tostr(str) == "" ) then return {} end

    local list = {}
    local word

    for word in gfind(str, pat or "%S+") do
        tinsert(list, word)
    end

    return list
end

-- Recursively iterate through the table and sub-tables until the entire table
-- structure is copied over.
function AceClass.CopyTable(into, from)
    local key, val

    if( ace.tonum(getn(from)) > 0 ) then
        for key, val in ipairs(from) do
            if( type(val) == "table" ) then
                tinsert(ace.CopyTable({}, val))
            else
                tinsert(into, val)
            end
        end
    else
        for key, val in from do
            if( type(val) == "table" ) then
                if( not into[key] ) then into[key] = {} end
                ace.CopyTable(into[key], val)
            else
                into[key] = val
            end
        end
    end

    return into
end

function AceClass.GetTableKeys(tbl)
    local t, key, val = {}
    for key, val in pairs(tbl) do
        tinsert(t, key)
    end
    return(t)
end

function AceClass.TableFindKeyCaseless(tbl, key)
    local i, val
    key = strlower(key)
    for i, val in tbl do
        if( strlower(i) == key ) then return i, val end
    end
end

function AceClass.concat(t,sep)
    local msg = ""
    local key, val
    if( getn(t) > 0 ) then
        for key, val in ipairs(t) do
            if( msg~="" and sep ) then msg = msg..sep end
            msg = msg..ace.tostr(val)
        end
    else
        for key, val in t do
            if( msg~="" and sep ) then msg = msg..sep end
            msg = msg..key.."="..ace.tostr(val)
        end
    end
    return msg
end

function AceClass.round(num)
    return floor(ace.tonum(num)+.5)
end

function AceClass.sort(tbl, comp)
    sort(tbl, comp)
    return tbl
end

function AceClass.strlen(str)
    return strlen(str or "")
end

function AceClass.ternary(c, a, b)
    if( c ) then return a else return b end
end

function AceClass.tonum(val, base)
    return tonumber((val or 0), base) or 0
end

function AceClass.tostr(val)
    return tostring(val or "")
end

function AceClass.toggle(val)
    if( val ) then return FALSE end
    return TRUE
end

function AceClass.trim(str, opt)
    if( (not opt) or (opt=="left" ) ) then str = gsub(str, "^%s*", "") end
    if( (not opt) or (opt=="right") ) then str = gsub(str, "%s*$", "") end
    return str
end


--[[--------------------------------------------------------------------------------
  Create the ace Object
-----------------------------------------------------------------------------------]]

ace     = AceClass:new()

-- Functions left unmapped in the UI. Mapped here for consistency.
concat  = table.concat
gfind   = string.gfind
strrep  = string.rep