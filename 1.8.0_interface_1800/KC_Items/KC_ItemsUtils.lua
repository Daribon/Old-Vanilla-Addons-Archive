
--[[-------------------------------------------------------------------------------------
	Common functions that KC_Items and its modules use that a part of the Ace Utilities
	library.

	These functions provide some common functionality that a function library could 
	supply but you only bring in the ones you need.
	
	And if everyone only brings in the ones you need then their is only going to be one 
	copy of each in memory.
----------------------------------------------------------------------------------------]]

ace:RegisterFunctions(KC_Items, {

-- Match this version to the library version you are pulling from.
version = 1.0,

-- Purpose: Splits a string into several values based on the supplied separator or
--          pattern.
-- Returns: A number of arguments equaling the number of parts the string is split
--          into.
SplitString = function(s,p,n)
	if (type(s) ~= "string") then
		error("SplitString must be passed a string as the first argument", 2)
	end
	
    local l,sp,ep = {},0
    while(sp) do
        sp,ep=strfind(s,p)
        if(sp) then
            tinsert(l,strsub(s,1,sp-1))
            s=strsub(s,ep+1)
        else
            tinsert(l,s)
            break
        end
        if(n) then n=n-1 end
        if(n and (n==0)) then tinsert(l,s) break end
    end
    return unpack(l)
end,

-- Purpose: Print text to the overhead (error frame) display.
-- Returns: none
PrintOverheadText = function(...)
    if( type(arg[1])=="table" ) then
        local p=tremove(arg,1)
        ace:print({(p[1] or 1.0),(p[2] or 1.0),(p[3] or 0),UIErrorsFrame,p[4]},unpack(arg))
    else
        ace:print(unpack(arg))
    end
end,

CashTextLetters = function(cash,sep,nocol)
    -- Arg order for these doesn't matter, so swap them if sep is TRUE
    if((sep==TRUE) or (sep==true)) then sep=nocol; nocol=TRUE end
    local g,s,c=ace.ParseCash(cash or 0)
    local str=""
    if(g>0) then
        if(nocol) then str=g..ACE_LETTER_GOLD
        else
            str=ace.ColorText(ACE_COLOR_HEX_GOLD,g..ACE_LETTER_GOLD)
        end
    end
    if(s>0) then
        if(str ~= "") then str = str..(sep or " ") end
        if(nocol) then str=str..s..ACE_LETTER_SILVER
        else
            str=str..ace.ColorText(ACE_COLOR_HEX_SILVER,s..ACE_LETTER_SILVER)
        end
    end
    if(c>0) then
        if(str ~= "") then str=str..(sep or " ") end
        if(nocol) then str=str..c..ACE_LETTER_COPPER
        else
            str=str..ace.ColorText(ACE_COLOR_HEX_COPPER,c..ACE_LETTER_COPPER)
        end
    end
    return str
end,

ParseCash = function(c)
    local c=ace.round(c or 0)
    return floor(c/(100*100)),mod(floor(c/100),100),mod(floor(c),100)
end,

ColorText = function(c,...)
    if( not c ) then return ace.concat(arg) end
    if type(c)=="table" then
        return "|cff"..ace.HexDigit(c[1] or c.r)..ace.HexDigit(c[2] or c.g)..
                       ace.HexDigit(c[3] or c.b)..ace.concat(arg).."|r"
    end
    return "|cff"..c..ace.concat(arg).."|r"
end,

})

ace:RegisterGlobals({
    version = 1.0,

    ACE_HEX = {0,1,2,3,4,5,6,7,8,9,"a","b","c","d","e","f"},

    ACE_COLOR_HEX_GOLD   = "ffd700",
    ACE_COLOR_HEX_SILVER = "c7c7cf",
    ACE_COLOR_HEX_COPPER = "eda55f",
    ACE_COLOR_HEX_CASH   = "00ff00",

    ACE_TEXT_GOLD        = "gold",
    ACE_TEXT_SILVER      = "silver",
    ACE_TEXT_COPPER      = "copper",

    ACE_LETTER_GOLD      = "g",
    ACE_LETTER_SILVER    = "s",
    ACE_LETTER_COPPER    = "c",
})