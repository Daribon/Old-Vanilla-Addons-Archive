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
	-- 	string - the string in byte code
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
			amount = amount + (string.byte(strsub(remain, 1, 1)) - string.byte("0"));
			remain = strsub(remain, 2);
		end
		return amount;		
	end;

	-- 
	-- fromTime(Number time)
	--
	-- 	Creates a readable time from a number time in WoW
	--
	-- Returns:
	-- 	(String timeString)
	-- 	timeString - the time
	-- 	
	fromTime = function (time)
		if (time < 0)	then
			time = 0;
		end
		
		local seconds = mod(floor(time), 60);
		if (seconds < 10)
			then
			seconds = "0"..seconds;
		end
		local minutes = mod(floor(time/60), 60);
		local hours = floor(time/(60*60));
		
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
};
