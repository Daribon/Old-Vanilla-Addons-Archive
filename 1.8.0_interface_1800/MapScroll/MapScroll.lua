--<< ================================================= >>--
-- Phase I: Initializing the Class.                      --
--<< ================================================= >>--

MapScrollClass    = AceAddonClass:new({
    name          = MAPSCROLL_TITLE,
    description   = MAPSCROLL_DESCRIPTION,
    version       = "a/R.1",
    author        = "Rowne",
    authorEmail   = "wuffxiii@gmail.com",
    aceCompatible = "100",
    category      = ACE_CATEGORY_MAP
})

function MapScrollClass:Initialize()
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
end

function MapScrollClass:Enable()
	self:Initialize()
end

function MapScrollClass:Disable()
	MinimapZoomIn:Show()
	MinimapZoomOut:Show()
end

--<< ================================================= >>--
-- Phase II: Creating the Minimap Scroller Functions.    --
--<< ================================================= >>--

function MapScrollClass:ZoomIn()
	if Minimap:GetZoom()== 5 then return end
	Minimap:SetZoom(Minimap:GetZoom() +1)
end

function MapScrollClass:ZoomOut()
	if Minimap:GetZoom()== 0 then return end
	Minimap:SetZoom(Minimap:GetZoom()- 1)
end

function MapScrollClass:Wheel(scroll)
	if scroll> 0 then self:ZoomIn() return end
	self:ZoomOut()
end

--<< ================================================= >>--
-- Phase Omega: Create and Register the AddOn Object.    --
--<< ================================================= >>--

MapScroll=MapScrollClass:new()
MapScroll:RegisterForLoad()