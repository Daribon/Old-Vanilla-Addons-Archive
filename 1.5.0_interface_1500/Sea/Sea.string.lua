--[[
--
--	Sea.string
--
--	String manipulation functions
--
--]]

Sea.string = {

	--
	-- byte(string)
	--
	--	Converts a character to its bytecode
	--
	-- Args:
	-- 	string - the string
	--
	-- Returns:
	-- 	(string)
	-- 	string - the string in byte code with format <##>
	--
	byte = function(c)
		return string.format("<%02X>",string.byte(c));
	end;

	--
	-- toInt (string s)
	--
	-- 	Converts the specified string to an int
	--
	-- Returns: 
	-- 	(Number int)
	-- 	int - the string S as a number
	--
	toInt = function (str)
		local remain = str;
		local amount = 0;
		while ( (remain ~= "") and (remain) ) do
			amount = amount * 10;
			amount = amount + (string.byte(string.sub(remain, 1, 1)) - string.byte("0"));
			remain = string.sub(remain, 2);
		end
		return amount;		
	end;

	-- 
	-- fromTime(Number time, Number decimalplaces)
	--
	-- 	Creates a readable time from a number time in WoW
	-- 	Decimal places gives the number of .### to display
	--
	-- Returns:
	-- 	(String timeString)
	-- 	timeString - the time
	-- 	
	fromTime = function (time, decimalplaces)
		if (time < 0)	then
			time = 0;
		end
		if ( not decimalplaces ) then 
			decimalplaces = 0;
		end
		
		local size = math.pow(10,decimalplaces);
		local seconds = math.mod(math.floor(time*size), 60*size);
		seconds = seconds / size;

		if (seconds < 10)
			then
			seconds = "0"..seconds;
		end
		local minutes = math.mod(math.floor(time/60), 60);
		local hours = math.floor(time/(60*60));
		
		local timeString;
		if (hours > 0)
			then
			if (minutes < 10)
				then
				minutes = "0"..minutes;
			end
			timeString = hours..":"..minutes..":"..seconds;
		else
			timeString = minutes..":"..seconds;
		end
		return timeString;
	end;

	--
	-- capitalizeWords(String phrase)
	--
	--	Takes a string like "hello world" and turns 
	--	it into "Hello World". 
	--
	-- Returns:
	-- 	(String capitalizedPhrase)
	-- 
	
	capitalizeWords = function ( phrase )
		local words = Sea.util.split(phrase, " ");
		local capitalizedPhrase = "";

		for i=1,words.n do 
			local v = words[i];
			if ( i ~= 1 ) then
				capitalizedPhrase = capitalizedPhrase.." ";
			end
			capitalizedPhrase = capitalizedPhrase..string.upper(string.sub(v,1,1))..string.sub(v,2);
		end

		return capitalizedPhrase;
	end;
};
