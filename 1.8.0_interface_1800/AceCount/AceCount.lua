--------------
--Class Setup
--------------

AceCount = AceAddon:new({
    name		= ACECOUNT.NAME,
    description		= ACECOUNT.DESCRIPTION,
    version		= "1.1",
    releaseDate		= "9-18-05",
    aceCompatible	= "102",
    author		= "Random",
    email		= "Toast.Theif@Gmail.com",
    website		= "http://www.WoWAce.com",
    category		= "ACE_CATEGORY_INVENTORY",
})

---------------------------
--Addon Enabling/Disabling
---------------------------

function AceCount:Enable()
    self:Hook("SetItemButtonCount", "AC_SetItemButtonCount")
end

------------------
--Main Processing
------------------

function AceCount:AC_SetItemButtonCount(button, count)
	if ( not button ) then 
		return 
	end

	if ( not count ) then
		count = 0
	end

	button.count = count
	if ( count > 1 or (button.isBag and count > 0) ) then
		if ( count > 999 ) then
			local fixedCount = count + 50
			count = floor((fixedCount)/1000).."."..floor(((mod(fixedCount, 1000))/100)).."k"
		end 
		getglobal(button:GetName().."Count"):SetText(count)
		getglobal(button:GetName().."Count"):Show()
	else
		getglobal(button:GetName().."Count"):Hide()
	end
	self:CallHook("SetItemButtonCount")
end

---------------------
--Register the Addon
---------------------

AceCount:RegisterForLoad()