--[[--------------------------------------------------------------------------------------------

MozzSoundVolumeFix: Standalone fix for the bug where sound volume is too loud after alt-tabbing.
	
--]]--------------------------------------------------------------------------------------------

-- By default, we will "fix" the sound volume every frame.  If you experience lag which you
-- think is attributable to this, you can change the "= 1" to "= 0" on the following line, and
-- reload your UI, and bind a key to the "Fix Sound Volume" in the Miscellaneous section instead.

local autoFixSoundVolume = 1

------------------------------------------------------------------------------------------------

BINDING_HEADER_SOUNDVOLUMEFIX = "Fix Sound Volume"
BINDING_NAME_SOUNDVOLUMEFIX = "Fix Sound Volume"

MezzSoundVolumeFix_LastFix = 0;

function FixSoundVolume()
    local svol = GetCVar("MasterVolume")+0
    if (MezzSoundVolumeFix_LastFix == 1) or (svol >= 1) then
        SetCVar("MasterVolume", svol-0.05)
        MezzSoundVolumeFix_LastFix = 0;
    else
        SetCVar("MasterVolume", svol+0.05)
        MezzSoundVolumeFix_LastFix = 1;
    end
    SetCVar("MasterVolume", svol)
end

local old_WorldFrame_OnUpdate = WorldFrame_OnUpdate;
function WorldFrame_OnUpdate(elapsed)
    old_WorldFrame_OnUpdate(elapsed)
    if autoFixSoundVolume==1 then FixSoundVolume() end
end

------------------------------------------------------------------------------------------------

-- end of file
