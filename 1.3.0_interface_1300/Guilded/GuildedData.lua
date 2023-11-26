--[[
-- 
-- GuildedData is used to simply store any dynamic data used by the Guilded AddOn.
--
--]]
GuildedData = {
    -- Members dynamic data functionality
	numMembers = 0;
    members = {};

    --[[
    -- resetMembers()
    --     Reset the member data
    --]]
	resetMembers = function()
	    GuildedData.numMembers = 0;
		GuildedData.members = {};
    end;


    --[[
    -- findMember( name )
    --     Find the member index with the given name
    --]]
	findMember = function( name )
	    if ( name ) then
			for k, member in GuildedData.members do
			    if (member.name == name) then
				    return k;
				end
			end
		end
		return -1;
    end;

    --[[
    -- addMember( name, class, level, guild )
    --     Add the member to the guilded data structure
    --]]
	addMember = function( name, class, level, guild )
		if ( name and class and level ) then
    	    local newMember = {};
    	    newMember.name = name;
	        newMember.class = class;
    	    newMember.level = level;
			if ( (not guild) or (guild == "") ) then
			    guild = "none";
			end
	        newMember.guild = guild;
			
			local idx = GuildedData.findMember(name);

			if ( idx > 0 ) then
        	    GuildedData.members[idx] = newMember;
			else
    	    	GuildedData.numMembers = GuildedData.numMembers + 1;
        	    table.insert(GuildedData.members, newMember);
			end
		end
	end;
	

    --[[
    -- delMember( name )
    --     Delete the member from the guilded data structure
    --]]
	delMember = function( name )
	    if ( name ) then
			local idx = GuildedData.findMember(name);
			if ( idx > 0 ) then
	            table.remove(GuildedData.members, idx);
    			if ( GuildedData.numMembers > 0 ) then
        		    GuildedData.numMembers = GuildedData.numMembers - 1;
		    	end
	    	end
		end
	end;
	

    --[[
    -- sortMembers( sortType, sortDir )
    --     Sort the members table by the given type
    --]]
	sortMembers = function ( sortType, sortDir )
        GuildedDataSort(GuildedData.members, sortType, sortDir );
	end;


	numStock = 0;
	stock = {};
	
	
    --[[
    -- resetItems()
    --     Reset the stock data
    --]]
	resetItems = function()
   	    GuildedData.numStock = 0;
    	GuildedData.stock = {};
    end;


    --[[
    -- findItem( link )
    --     Find the stock index for the given item link
    --]]
	findItem = function( link, owner )
	    if ( link and owner ) then
			for i, stockData in GuildedData.stock do
			    if ( (stockData.link == link) and (stockData.owner == owner) ) then
				    return i;
				end
			end
		end
		return -1;
    end;

	
    --[[
    -- addItem( link, texture, itemCount, locked, quality, price )
    --     Add the item to the guilded config stock data structure
    --]]
	addItem = function( link, texture, itemCount, locked, quality, price, owner )
		if ( link and texture and owner ) then
    	    local newItem = {};
    	    newItem.link = link;
	        newItem.texture = texture;
    	    newItem.itemCount = itemCount;
	        newItem.locked = locked;
    	    newItem.quality = quality;
    	    newItem.price = price;
    	    newItem.owner = owner;

		    local idx = GuildedData.findItem(link, owner);
		    if (idx > 0) then
        	    newItem.wts = GuildedData.stock[idx].wts;
        	    newItem.wtb = GuildedData.stock[idx].wtb;
			    GuildedData.stock[idx] = newItem;
			else
        	    newItem.wts = false;
        	    newItem.wtb = false;
       	    	GuildedData.numStock = GuildedData.numStock + 1;
           	    table.insert(GuildedData.stock, newItem);
			end
		end
	end;
	

    --[[
    -- delItem( link )
    --     Delete the item from the guilded config stock data structure
    --]]
	delItem = function( link, owner )
	    if ( link and owner ) then
			local idx = GuildedData.findItem(link, owner);
			if ( idx > 0 ) then
			    if ( (not GuildedData.stock[idx].wts) and (not GuildedData.stock[idx].wtb) ) then
                    table.remove(GuildedData.stock, idx);
   	        		if ( GuildedData.numStock > 0 ) then
       	        	    GuildedData.numStock = GuildedData.numStock - 1;
   		        	end
       	    	end
   	    	end
		end
	end;
	

    --[[
    -- getItemTable( stockType )
    --     Build and return a table with items of the given stock type
    --]]
	getItemTable = function( stockType )
	    itemTable = {};
	    if ( stockType == "WTS" ) then
			for i, stockData in GuildedData.stock do
			    if (stockData.wts == true) then
				    table.insert(itemTable, stockData);
				end
			end
	    elseif ( stockType == "WTB" ) then
			for i, stockData in GuildedData.stock do
			    if (stockData.wtb) then
				    table.insert(itemTable, stockData);
				end
			end
		end
		return itemTable;
    end;
	

    --[[
    -- flagItem( link, flag, val )
    --     Flag the item as WTS or WTB
    --]]
	flagItem = function( link, owner, flag, val )
	    if ( link and flag and (val ~= nil) ) then
			local idx = GuildedData.findItem(link, owner);
			if ( idx > 0 ) then
			    if (flag == "WTS") then
					GuildedData.stock[idx].wts = val;
				elseif (flag == "WTB") then
					GuildedData.stock[idx].wtb = val;
				end
   	    	end
		end
	end;

	
    -- Crafters dynamic data functionality
    numCrafters = 0;
    crafters = {};
	

    --[[
    -- resetCrafters( name )
    --     Reset the crafter data
    --]]
	resetCrafters = function()
	    GuildedData.numCrafters = 0;
		GuildedData.crafters = {};
    end;


    --[[
    -- findCrafter( name, startIdx )
    --     Find the crafter index with the given name
    --]]
	findCrafter = function( name, startIdx )
	    if ( name ) then
		    local start = 1;
		    local finish = table.getn(GuildedData.crafters);
		    if ( startIdx and ( startIdx > 0 ) ) then
			    start = startIdx;
			end
			
			if (start > finish ) then
			    return -1;
			end
			
			for i = start, finish do
			    if (GuildedData.crafters[i].name == name) then
				    return i;
				end
			end
		end
		return -1;
    end;

    --[[
    -- addCrafter( name, prof, cat, level )
    --     Add the crafter to the guilded data structure
    --]]
	addCrafter = function( name, prof, cat, level )
		if ( name and prof and level ) then
    	    local newCrafter = {};
    	    newCrafter.name = name;
	        newCrafter.prof = prof;
    	    newCrafter.level = level;
			if ( (not cat) or (cat == "") ) then
			    cat = "none";
			end
	        newCrafter.cat = cat;
			
			local idx = GuildedData.findCrafter(name);
			while (idx > 0 ) do
			    if ( GuildedData.crafters[idx].prof == newCrafter.prof ) then
            	    GuildedData.crafters[idx] = newCrafter;
					return;
				end
    			idx = GuildedData.findCrafter(name, idx + 1);
			end
			
   	    	GuildedData.numCrafters = GuildedData.numCrafters + 1;
       	    table.insert(GuildedData.crafters, newCrafter);
		end
	end;
	

    --[[
    -- delCrafter( name )
    --     Delete the crafter from the guilded data structure
    --]]
	delCrafter = function( name )
	    if ( name ) then
			local idx = GuildedData.findCrafter(name);
			while ( idx > 0 ) do
	            table.remove(GuildedData.crafters, idx);
    			if ( GuildedData.numCrafters > 0 ) then
        		    GuildedData.numCrafters = GuildedData.numCrafters - 1;
		    	end
				idx = GuildedData.findCrafter(name);
	    	end
		end
	end;
	

    --[[
    -- sortCrafters( sortType, sortDir )
    --     Sort the crafters table by the given type
    --]]
	sortCrafters = function ( sortType, sortDir )
        GuildedDataSort(GuildedData.crafters, sortType, sortDir );
	end;
};


--[[
-- GuildedDataSort( sortTable, sortType, sortDir )
--     Generic table sort function
--]]
GuildedDataSort = function( sortTable, sortType, sortDir )
    if ( sortTable and sortType ) then
	    if ( sortDir ) then
	        table.sort(sortTable, function(a, b)
    		    return (a[sortType] < b[sortType]);
		    end);
	    else
	        table.sort(sortTable, function(a, b)
    		    return (a[sortType] > b[sortType]);
		    end);
	    end
    end
end;
