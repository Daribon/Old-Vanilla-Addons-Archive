-- This statement will load any translation that is present or default to English.
local loader = getglobal("KC_Items_Locals_"..GetLocale())
if ( loader ) then loader()
else

ace:RegisterGlobals({
    -- Match this version to the library version you are pulling from.
    version = 1.0,

    -- Place any AceUtil globals your addon needs here
})

KC_ITEMS_NAME          = "KC_Items"
KC_ITEMS_DESCRIPTION   = "A centralized repository for item, bank, and inventory data."

-- Chat handler locals
KC_ITEMS_COMMANDS      = {"/kcitems", "/kci"}

KC_ITEMS_SELLS_FOR           = "|cffffff78Sell Price%s:|r"

end


loader = nil
