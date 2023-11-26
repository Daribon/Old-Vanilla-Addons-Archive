--[[
--
--	Sea.table
--
--	LUA Table manipulation functions
--
--]]

Sea.table = {
	
	-- 
	-- getValueIndex(table, value)
	--
	-- 	Returns the key associated with the value in the table/list.
	--
	-- Args:
	-- 	(table t, object item)
	--	t - table to search
	--	item - item to find the index of
	--
	-- Returns: 
	-- 	nil - if empty
	-- 	index - if found
	getValueIndex = function (table, item) 
		for k,v in table do 
			if ( v == item ) then return k; end
		end
		return nil;
	end;

	--
	-- isInTable(table, value ) 
	--
	-- Returns:
	-- 	true if the item is in the list/table
	-- 	false if not in the list/table
	--
	isInTable = function(table, value)
		return (Sea.table.getValueIndex(table,value) ~= nil )
	end;

	--
	-- isStringInTableValue(table[string] table, string word)
	--
	-- Returns:
	-- 	true if word exists in a string value of table
	-- 	false if word is never used
	--
	-- Aliases:
	-- 	isWordInList()
	--
	isStringInTableValue = function (table, word) 
		for k,v in table do
			if ( type(v) == "string" ) then 
				if ( string.find(word,v) ~= nil ) then
					return true;
				end
			end
		end
		return false;
	end;
	
	--
	-- Aliases:
	-- 	Sea.table.getIndexInList
	-- 	Sea.list.getIndexInList
	-- 
	
	-- 
	-- push( table, value )
	--
	-- 	Adds a value to the end of the table.
	--
	-- Arg:
	-- 	table - the table
	-- 	value - the value for the end of the table
	-- 
	push = function (table,val)
		if(not table or not table.n) then
			Sea.IO.derror(nil, "Bad table passed to push");
			return nil;
		end
		table.n = table.n+1;
		table[table.n] = val;
	end;

	--
	-- pop ( table )
	--
	-- 	Removes a value and returns it from the table
	-- Arg:
	-- 	table - the table
	--
	pop = function (table)
		if(not table or not table.n) then
			Sea.IO.derror(nil,"Bad table passed to pop");
			return nil;
		end
		if ( table.n == 0 ) then 
			return nil;
		end

		local v = table[table.n];
		table.n = table.n - 1;
		return v;		
	end;
};

-- Aliases
Sea.table.getIndexInList = Sea.table.getValueIndex;
Sea.table.isWordInList = Sea.table.isStringInTableValue;

-- List and tables are equal in lua
Sea.list = Sea.table;
