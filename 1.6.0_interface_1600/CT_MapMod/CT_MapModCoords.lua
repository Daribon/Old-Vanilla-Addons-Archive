--[[

x1280: -0.5
x1152: -0.5
x1360: -0.5
x1600: -0.5
x1920: -0.5
x1792: -0.5
x1856: -0.5
x1800: -0.5
x2048: -0.5

y720: -0.03
y768: -0.03
y864: -0.025
y960: -0.03
y1080: -0.03
y1200: -0.025
y1344: -0.025
y1392: -0.025
y1440: -0.025
y1536: -0.03

]]

function CT_GetScreenResolution(...)
	local resolution, xIndex, width, height;
	for i = 1, arg.n, 1 do
		if ( i == GetCurrentResolution() ) then
			resolution = arg[i];
			xIndex = strfind(resolution, "x");
			width = strsub(resolution, 1, xIndex-1);
			height = strsub(resolution, xIndex+1, strlen(resolution));
			resx = width; resy = height;
			return;
		end
	end
	resx = "1024"; resy = "768";
end

xconstant, yconstant = nil;
CT_GetScreenResolution(GetScreenResolutions());
if ( resx and resy ) then
	if ( resx == "1280" and resy == "1024" ) then
		xconstant  = 0.0022;
		yconstant = -0.0262;
	elseif ( resx == "800" and resy == "600" ) then
		xconstant =  0.002;
		yconstant = -0.035;
	elseif ( resx == "1024" and resy == "768" ) then
		xconstant = 0.002;
		yconstant = -0.03;
	else
		xconstant = 0;
		yconstant = 0;
	end
end
		

function CT_CoordMod_OnUpdate()
	local x, y = GetCursorPosition();
	x = x / WorldMapFrame:GetScale();
	y = y / WorldMapFrame:GetScale();

	local w, h, cx, cy, ax, ay, px, py;
	w = WorldMapButton:GetWidth();
	h= WorldMapButton:GetHeight();
	cx, cy = WorldMapFrame:GetCenter();
	
	ax = (x - (cx - (w/2))) / w;
	ay = (cy + (h/2) - y) / h;

	x = floor((ax + xconstant) * 100);
	y = floor((ay + yconstant) * 100);

	local px, py = GetPlayerMapPosition("player");
	px = floor(px * 100);
	py = floor(py * 100);

	if ( x < 0 ) then
		x = "0";
	end
	if ( y < 0 ) then
		y = "0";
	end
	CT_CoordX:SetText("X: " .. x .. " (" .. px .. ")");
	CT_CoordY:SetText("Y: " .. y .. " (" .. py .. ")");
end

function CT_FindOffsets()
	CT_GetScreenResolution(GetScreenResolutions());
	local w, h, cx, cy, ax, ay, px, py;
	px, py = GetPlayerMapPosition("player");
	px = floor(px * 100);
	py = floor(py * 100);

	local x, y = GetCursorPosition();
	x = x / WorldMapFrame:GetScale();
	y = y / WorldMapFrame:GetScale();

	w = WorldMapButton:GetWidth();
	h= WorldMapButton:GetHeight();
	cx, cy = WorldMapFrame:GetCenter();
	
	ax = (x - (cx - (w/2))) / w;
	ay = (cy + (h/2) - y) / h;

	local xoff = -0.25;
	local yoff = -0.5;
	local step = 0.005;

	x = floor(ax * 100);
	y = floor(ay * 100);
	if ( x == px and y == py ) then
		CT_Print("x: 0 | y: 0");
	else
		while ( xoff <= 0.5 ) do
			xoff = xoff + step;
			x = floor((ax+xoff) * 100);
			CT_Print("Trying " .. x .. " vs " .. px .. " with offset " .. xoff);
			if ( x == px ) then
				CT_Print("x: " .. xoff);
				break;
			end
		end
		while ( y ~= py and yoff <= 0.5 ) do
			yoff = yoff + step;
			y = floor((ay+yoff) * 100);
		end
		if ( y == py  ) then
			CT_Print("y: " .. yoff);
		end
		CT_Print("Resolution: " .. resx .. "x" .. resy);
	end
end