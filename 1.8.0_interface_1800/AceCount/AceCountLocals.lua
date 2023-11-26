ACECOUNT = {}

if( not ace:LoadTranslation("AceCount") ) then

ace:RegisterGlobals({
    version = 1.2,
})

ACECOUNT.NAME		= "AceCount"
ACECOUNT.DESCRIPTION	= "Displays #.#k instead of * for item counts > 999."

end