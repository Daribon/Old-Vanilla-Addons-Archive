local DEFAULT_OPTIONS =	{};

KC_ItemsClass = AceAddonClass:new({
	name		  =	KC_ITEMS_NAME,
	description	  =	KC_ITEMS_DESCRIPTION,
	version		  =	"0.93",
	releaseDate   = "10/14/05",
	aceCompatible =	"102", -- Check	ACE_COMP_VERSION in	Ace.lua	for	current.
	author		  =	"Kaelten",
	email		  =	"kaelten@gmail.com",
	website		  =	"http://www.kaelcycle.org",
	category	  =	"inventory",
	defaults	  =	DEFAULT_OPTIONS,
	db			  =	AceDbClass:new("KC_ItemsDB"),
	cmd			  =	AceChatCmdClass:new(KC_ITEMS_COMMANDS, KC_ITEMS_CMD_OPTIONS)
})

-- Module Management

function KC_ItemsClass:Register(module)
	if( not self.modules ) then self.modules = {} end
	self.modules[module.type] = module
	self[module.type] = module
	module.app = self
	module:Register()
	if( module.cmdOptions ) then
		module.cmdOptions.handler = module
		tinsert(module.cmdOptions.args or {}, 1, KC_ITEMS_CMD_TOGGLE)
		tinsert(self.cmd.options, module.cmdOptions)
	end
end

-- Need at least an empty Enable so Ace will provide enable/disable features.
function KC_ItemsClass:Enable()
	self.statsPath = {"stats"};
	self.colors	= KC_Items_Colors;

	self:_stats();
	self:install();
end

-- Data Access Closures

function KC_ItemsClass:GetOpt(var, path)
	local profilePath = self.profilePath;
	if (path) then
		profilePath = {self.profilePath, path};
	end
	return self.db:get(profilePath, var)
end

function KC_ItemsClass:SetOpt(var, val, path)
	local profilePath = self.profilePath;
	if (path) then
		profilePath = {self.profilePath, path};
	end
	return self.db:set(profilePath, var, val)
end

function KC_ItemsClass:TogOpt(var, path)
	local profilePath = self.profilePath;
	if (path) then
		profilePath = {self.profilePath, path};
	end
	return self.db:toggle(profilePath, var)
end

function KC_ItemsClass:SetModState(mod, state)
	self.db:set({self.profilePath, "modules"}, mod.type, ace.toggle(state))
end

function KC_ItemsClass:ModEnabled(mod)
	return ace.toggle(self.db:get({self.profilePath, "modules"}, mod.type))
end


-- Command Reporting Closures

function KC_ItemsClass:Msg(...)
	self.cmd:result(KC_ITEMS_MSG_COLOR, unpack(arg))
end

function KC_ItemsClass:Result(text, val, map)
	if( map ) then val = map[val or 0] or val end
	self.cmd:result(KC_ITEMS_MSG_COLOR, text, " ", ACEG_TEXT_NOW_SET_TO, " ",
					format(KC_ITEMS_DISPLAY_OPTION, val or ACE_CMD_REPORT_NO_VAL)
				   )
end

function KC_ItemsClass:TogMsg(var, text)
	local val = self:TogOpt(var)
	self:Result(text, val, ACEG_MAP_ONOFF)
	return val
end

function KC_ItemsClass:Error(...)
	self.cmd:result(format(unpack(arg)))
end


-- Command Handlers

function KC_ItemsClass:Report()
	-- Display KCI core Options.
	--self.cmd:report()

	-- Display status of modules
	if( self.modules ) then
		local rpt, mod, _ = {}
		for _, mod in self.modules do
			tinsert(rpt, {text=mod.name, val=ace.toggle(mod.disabled), map=ACEG_MAP_ENABLED})
		end
		self.cmd:report(KC_ITEMS_RPT_HDR_MODULES, rpt)
	else
		ace:print(KC_ITEMS_TEXT_NO_MODULES)
	end
end

-- Link Functions.
function KC_ItemsClass:_id(link)
	if (not link) then return nil;	end
	local _,_, code = strfind(link, "(%d+):")
	return code;
end

function KC_ItemsClass:_code(link)
	if (not link) then return nil; end
	local _, _, code = strfind(link, "(%d+:%d+:%d+:%d+)");
	local code = code and gsub(code, "(%d+):(%d+):(%d+):(%d+)", "%1:0:%3:0");
	return code;
end

function KC_ItemsClass:GetCode(link, sell, cost)
	code = self:_code(link);
	if (not code) then return nil; end

	self:AddCode(code, sell, cost);
	return code;
end

function KC_ItemsClass:AddCode(code, sell, cost)
	if (not	code) then return nil; end

	if (not	self.db:get(code)) then
		local value = (sell or "0") .. ":" .. (cost or "0");
		self.db:set(code, value);
		self:incCount();
		if (sell and tonumber(sell) > 0) then self:incSell(); end
		if (cost and tonumber(cost) > 0) then self:incCost(); end
	end

	return id;
end

function KC_ItemsClass:RemoveCode(code) 
	if (not	code)	then return	nil; end

	local data = self.db:get(code);
	if (not data) then return nil; end

	self.db:set(code, nil);

	sell, cost = self.SplitString(data, ":");
	
	self:decCount();
	if (tonumber(sell)) then
		if (tonumber(sell) > 0) then self:decSell(); end	
	end
	if (tonumber(cost)) then
		if (tonumber(cost) > 0) then self:decCost(); end		
	end
end

function KC_ItemsClass:GetCodeByName(name)
	for bagNum = 0, 4 do
		for bagItem = 1, GetContainerNumSlots(bagNum) do
			itemLink = GetContainerItemLink(bagNum, bagItem);
			if ( itemLink ) then
				local id = self:GetCode(itemLink);
				if (id) then
					if (self:GetName(id) == name) then
						return id;				
					end
				end			
			end
		end
	end	
end

function KC_ItemsClass:GetItemPrices(code)
	if (not code) then return; end
	local data = self.db:get(code);
	sell, buy = self.SplitString(data, ":");
	return tonumber(sell), tonumber(buy);
end
function KC_ItemsClass:SetItemPrices(code, sell, buy)
	if (not code) then return;end
	sell = sell and sell or 0;
	buy = buy and buy or 0;
	
	store = sell .. ":" .. buy;

	self.db:set(code, store);
end

function KC_ItemsClass:GetID(link)
	id = self:_id(link);	
	if (not	id)	then return	nil; end

	self:GetCode(link);
	return id;
end

-- Returns a valid items full name.
function KC_ItemsClass:GetName(id, trunc)
	if (self._cId == id and not trunc) then
		return self._cName;
	elseif (self._cId ~= id) then
		self:_CacheItemData(id);
	end

	local name = self._cName;
	if (trunc and name) then
		local l = string.len(name);
		if (l > trunc) then
			name = strsub(name, 1, trunc - 4) .. " ...";
		end
	end
	return name;		

end

-- Returns a hyperlink for a valid item.  item:xxxxx:xxx:xxx:xxx
function KC_ItemsClass:GetHyperlink(id)
	if (self._cId == id) then
		return self._cLink;		
	end
	self:_CacheItemData(id);
	return self._cLink;	
end

-- Returns a full textlink for a valid item.
function KC_ItemsClass:GetTextLink(id)
	if (self._cId ~= id) then
		self:_CacheItemData(id);	
	end	
	local color	= self:GetColorCode(id);
	local link	= self:GetHyperlink(id);
	local name	= self:GetName(id);
	
	if (not	color or not link or not name) then
		return nil;
	end
	local textLink = color .. "|H" .. link	.. "|h[" ..	name.. "]|h|r";

	return textLink;
end

-- Returns a numeric based quality value
function KC_ItemsClass:GetQuality(id)
	if (self._cId == id) then
		return self._cQuality;		
	end
	self:_CacheItemData(id);
	return self._cQuality; 
end

-- Returns the minimal level of	an item.
function KC_ItemsClass:GetMinLevel(id)
	if (self._cId == id) then
		return self._cMinLevel;		
	end
	self:_CacheItemData(id);
	return self._cMinLevel;	
end

-- Returns the item	type.  "Armor"
function KC_ItemsClass:GetClass(id)
	if (self._cId == id) then
		return self._cClass;		
	end
	self:_CacheItemData(id);
	return self._cClass; 
end

-- Returns the items subtype.  "Cloth"
function KC_ItemsClass:GetSubClass(id)
	if (self._cId == id) then
		return self._cSubclass;		
	end
	self:_CacheItemData(id);
	return self._cSubclass;	
end

-- Returns the max stack size.	"20"
function KC_ItemsClass:GetMaxStackSize(id)
	if (self._cId == id) then
		return self._cMaxStack;		
	end
	self:_CacheItemData(id);
	return self._cMaxStack;	
end

-- Returns the 6 digit hex for a color.
function KC_ItemsClass:GetColor(id)
	if (self._cId ~= id) then
		self:_CacheItemData(id);	
	end	
	return self.colors[self._cQuality] or nil;
end

-- Returns the 6 digit hex for a color.
function KC_ItemsClass:GetQuality(id)
	if (self._cId ~= id) then
		self:_CacheItemData(id);	
	end	
	return self._cQuality or nil;
end

-- Returns the 6 digit hex for a color.
function KC_ItemsClass:GetLocation(id)
	if (self._cId ~= id) then
		self:_CacheItemData(id);	
	end	
	return self._cLoc or nil;
end

-- Returns the wow Color code.
function KC_ItemsClass:GetColorCode(id)
	local color	= self:GetColor(id);
	if (not	color) then
		return nil;
	end
	return "|cff" .. color;
end

-- Returns the name	witht he corresponding color code prefixed.
function KC_ItemsClass:GetColoredName(id, trunc)
	local name = (self:GetColorCode(id)	or "") .. (self:GetName(id, trunc)	or "");
	if (name ==	"")	then
		return nil;
	end
	return name;
end

function KC_ItemsClass:install()
	local version =	self.db:get("v") or	".01";

	if (version	== ".01") then
		local items	= self.db._table;

		for	color =	1, 5 do
			if (items and items[color]) then
				for	desc = 0, 39 do
					if (items[color][desc])	then
						for	data in	items[color][desc] do
							if (data) then
								stuff =	items[color][desc][data];
								items[color][desc][data] = nil;
								if (string.find(stuff, ":")) then
									local x, y,	price =	ace.SplitString(stuff, ",")
									nData = data .. ":0:0:0";
									self.db:set(nData, ( price or "0"))
								end
							end
						end				   
					end
				end
			end
		end	
		
		for	color =	1, 5 do
			if (items and items[color]) then
				for	desc = 0, 39 do
					if (items[color][desc])	then
						items[color][desc] = nil;				   
					end
				end		
				items[color] = nil;
			end
		end	

		local pCount = 0;
		local tCount = 0;
		if (self.db._table) then
			for data in self.db._table do
				if (type (self.db._table[data]) == "string") then
					local price = ace.SplitString(self.db._table[data], ",")
					price = price and tonumber(price) or 0;
					if (price > 0) then
						pCount = pCount + 1;
					end
					tCount = tCount + 1;		
				end
			end
		end
		
		self.db:set("pricecount", nil);
		self.db:set("count", nil);
		self.db:set("pricepercentage", nil);

		self.db:set(self.statsPath, "svCnt", pCount);
		self.db:set(self.statsPath,	"cnt", tCount);
		self.db:set(self.statsPath,	"ctPer", pCount / tCount);
		
		self.db:set("v", self.version )

		return "done";
	end	

	if (version == ".90" or version == ".91") then
		local items	= self.db._table;

		for data in items do
			if (data ~= "v" and data ~= "profiles" and data ~= "stats") then
				if (not string.find(data, ":")) then
					nData = data .. ":0:0:0";
					local info = items[data];
					self.db:set(nData, info);
					self.db:set(data, nil);
				end
			end
		end
		
		self.db:set("v", self.version);
		
		return "done";
	end
end

--[[--------------------------------------------------------------------------------
  Helper Functions
-----------------------------------------------------------------------------------]]
function KC_ItemsClass:incCount()
	local cnt = self.db:get(self.statsPath, "cnt")+1;
	local svCnt = self.db:get(self.statsPath, "svCnt");
	local ctCnt = self.db:get(self.statsPath, "ctCnt");

	local svPer = svCnt / cnt;
	local ctPer = ctCnt / cnt;

	self.db:set(self.statsPath, "svPer", svPer);
	self.db:set(self.statsPath, "ctPer", ctPer);
	self.db:set(self.statsPath, "cnt", cnt);
end

function KC_ItemsClass:incSell()
	local cnt = self.db:get(self.statsPath, "cnt");
	local svCnt = self.db:get(self.statsPath, "svCnt")+1;

	local svPer = svCnt / cnt;

	self.db:set(self.statsPath, "svPer", svPer);
	self.db:set(self.statsPath, "svCnt", svCnt);
end

function KC_ItemsClass:incCost()
	local cnt = self.db:get(self.statsPath, "cnt");
	local ctCnt = self.db:get(self.statsPath, "ctCnt")+1;

	local ctPer = ctCnt / cnt;

	self.db:set(self.statsPath, "ctPer", ctPer);
	self.db:set(self.statsPath, "ctCnt", ctCnt);
end

function KC_ItemsClass:decCount()
	local cnt = self.db:get(self.statsPath, "cnt")-1;
	local svCnt = self.db:get(self.statsPath, "svCnt");
	local ctCnt = self.db:get(self.statsPath, "ctCnt");

	local svPer = svCnt / cnt;
	local ctPer = ctCnt / cnt;

	self.db:set(self.statsPath, "svPer", svPer);
	self.db:set(self.statsPath, "ctPer", ctPer);
	self.db:set(self.statsPath, "cnt", cnt);
end

function KC_ItemsClass:decSell()
	local cnt = self.db:get(self.statsPath, "cnt");
	local svCnt = self.db:get(self.statsPath, "svCnt")-1;

	local svPer = svCnt / cnt;

	self.db:set(self.statsPath, "svPer", svPer);
	self.db:set(self.statsPath, "svCnt", svCnt);
end

function KC_ItemsClass:decCost()
	local cnt = self.db:get(self.statsPath, "cnt");
	local ctCnt = self.db:get(self.statsPath, "ctCnt")-1;

	local ctPer = ctCnt / cnt;

	self.db:set(self.statsPath, "ctPer", ctPer);
	self.db:set(self.statsPath, "ctCnt", ctCnt);
end

function KC_ItemsClass:_stats(forced)
	local x = self.statsPath;
	
	local cnt   = self.db:get(x, "cnt");
	local svCnt = self.db:get(x, "svCnt");
	local ctCnt = self.db:get(x, "ctCnt");
	local svPer = self.db:get(x, "svPer");
	local ctPer = self.db:get(x, "ctPer");

	if (not cnt or forced) then
		self.db:set(x, "cnt", 0);
	end
	if (not svCnt or forced) then
		self.db:set(x, "svCnt", 0);
	end
	if (not ctCnt or forced) then
		self.db:set(x, "ctCnt", 0);
	end
	if (not svPer or forced) then
		self.db:set(x, "svPer", 0);
	end
	if (not ctPer or forced) then
		self.db:set(x, "ctPer", 0);
	end
end

function KC_ItemsClass:GetStat(stat)
	return self.db:get(self.statsPath, stat);
end

function KC_ItemsClass:_CacheItemData(id)
	if (self._cId == id) then error("_CacheItemData	called with	a redundent	ID,	check before you ask", 2) end
	
	if (strfind(id, ":") and not strfind(id, "item:")) then
		id = "item:" .. id;
	end

	local name,	link, quality, minLevel, class,	subclass, maxStack, location = GetItemInfo(id);

	self._cId =	id;
	self._cName	= name;
	self._cLink	= link;
	self._cQuality = quality;
	self._cMinLevel	= minLevel;
	self._cClass = class;
	self._cSubclass	= subclass;
	self._cMaxStack	= maxStack;

	if (location and type(location) == "string" and string.len(location) > 0) then
		self._cLoc = location;
	else 
		self._cLoc = nil;
	end

	return minLevel;
end

-- Utility Functions

function KC_ItemsClass:GetCharList(realm, faction)
	if (not realm) then realm = ace.char.realm; end
	if (not faction) then faction = ace.char.faction; end
	
	local result = {};

	if (KC_Bank) then
		local bank = KC_Bank.db:get();
				
		for index in bank do
			local charName , realmID= self.SplitString(index, " of ");
			local factionID = KC_Bank.db:get({index}, "faction");
			if (realmID == realm and factionID == faction) then
				result[index] = {
					name = charName,
					realm = realmID,
					faction = factionID,
				};
			end
		end	
	end
	
	if (KC_Inventory) then
		local inv = KC_Inventory.db:get();

		for index in inv do
			local factionID = KC_Inventory.db:get({index}, "faction");
			local charName , realmID = self.SplitString(index, " of ");
			if (realmID == realm and factionID == faction) then
				result[index] = {
					name = charName,
					realm = realmID,
					faction = factionID,
				};
			end
		end
	end
	
	return result;
end

-- Create The Addon
KC_Items = KC_ItemsClass:new()
KC_Items:RegisterForLoad()
