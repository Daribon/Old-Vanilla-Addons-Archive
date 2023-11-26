--[[
	ArmorCalculator v0.1 alpha

	This addon simply works as a storage layer for damage reduction information.
	As usual, its name is not quite as descriptive as I would have liked.
	Oh well.
	I have tried to supply luadoc entries with all functions.

	A version history should be possible to view in changelog.txt

	Thanks to my friends, especially Elderwyn, Modain, Kellmar and Sömnlös, 
	as well as all my guildies for helping me out during my depressed period!
	I hope to be back coding addons a long while now! :-)

	/sarf

	Repository URL:
	http://www.fukt.bth.se/~k/wow/scripts/ArmorCalculator/

	wiki URL:
	http://not.yet/

	Addon Status:
	In development.
]]


ArmorCalculator_Options_Default = {
	-- Use Player Level:
	--  This determines if player level should be kept in mind when adding 
	--  data points and retrieving entries. Because the author can not test
	--  the two differing modes it is kept as an option so as to allow ingame 
	--  testing and development.
	usePlayerLevel = true;
	-- Cutoff Level Difference:
	--  If the difference between the player level and the entitys level 
	--  becomes too great, the data gathered is useless (from a damage 
	--  reduction / armor calculation perspective, at least).
	--  This option determines where this cutoff point is. 
	--  It works in both ways - X levels above and below.
	cutoffLevelDifference = 10;
	-- Strict Memory Usage:
	--  This will try to ensure that the data kept in memory is kept to the 
	--  bare essentials without comprimising data.
	--  In effect, it will make it necessary to reload the UI when you want 
	--  to toggle usePlayerLevel, because it will remove the unused entries.
	strictMemoryUsage = false;
	-- Very Strict Memory Usage:
	--  This will try to ensure that the data kept in memory is kept to the 
	--  bare essentials. It may cause data loss, because the user database 
	--  will be pruned.
	veryStrictMemoryUsage = false;
};

ArmorCalculator_Options = {};
ArmorCalculator_Database_Base = {};
ArmorCalculator_Database_User = {};

--- Handles event registering and other things.
-- @usage for internal use only
function ArmorCalculator_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
end

--- Event handling
-- @usage for internal use only
function ArmorCalculator_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		ArmorCalculator_OnVariablesLoaded();
	end
end

--- Handles the particular event VARIABLES_LOADED
-- Sets up default options et cetera.
-- @usage for internal use only
function ArmorCalculator_OnVariablesLoaded()
	if ( not ArmorCalculator_Database_Base ) then
		ArmorCalculator_Database_Base = {};
	end
	if ( not ArmorCalculator_Database_User ) then
		ArmorCalculator_Database_User = {};
	end
	for key, value in pairs(ArmorCalculator_Options_Default) do
		if ( ArmorCalculator_Options[key] == nil ) then
			ArmorCalculator_Options[key] = value;
		end
	end
	-- TODO: is player level known at "VARIABLES_LOADED"?
	ArmorCalculator_CleanseDatabase();
end

--- Sets the option Strict Memory Usage.
-- @param value The new value of the Strict Memory Usage option (true/false).
function ArmorCalculator_SetStrictMemoryUsage(value)
	if ( value == true ) or ( value == false ) then
		ArmorCalculator_Options.strictMemoryUsage = value;
		ArmorCalculator_CleanseDatabase();
	end
end


--- Sets the option Very Strict Memory Usage.
-- Will cleanse the database
-- @param value The new value of the Very Strict Memory Usage option (true/false).
function ArmorCalculator_SetVeryStrictMemoryUsage(value)
	if ( value == true ) or ( value == false ) then
		ArmorCalculator_Options.veryStrictMemoryUsage = value;
		ArmorCalculator_CleanseDatabase();
	end
end


--- Sets the option Use Player Level.
-- @param value The new value of the Use Player Level option (true/false).
function ArmorCalculator_SetUsePlayerLevel(value)
	if ( value == true ) or ( value == false ) then
		ArmorCalculator_Options.usePlayerLevel = value;
		ArmorCalculator_CleanseDatabase();
	end
end

--- Sets the option Cutoff Level Difference.
-- @param value The new value of the Cutoff Level Difference option (non negative number).
function ArmorCalculator_SetUsePlayerLevel(value)
	if ( value >= 0 ) then
		ArmorCalculator_Options.cutoffLevelDifference = value;
		if ( value > 0 ) then
			ArmorCalculator_CleanseDatabase();
		end
	end
end

ArmorCalculator_CleanseDatabase_Base = {};
ArmorCalculator_CleanseDatabase_Cutoff = nil;

--- Cleanses the database, if necessary.
-- This function cleanses different amounts depending on how much memory 
-- usage the addon is allowed.
-- Note that some minor purging is always done on load time (at least for 
-- multi-locale distributions).
-- There are a few minor speedups associated with the cleansing which 
-- should make "very strict" memory usage a bit less tiresome.
-- @usage for internal use only
function ArmorCalculator_CleanseDatabase()
	if ( ArmorCalculator_Options.strictMemoryUsage ) 
	or ( ArmorCalculator_Options.veryStrictMemoryUsage ) then
		local usePlayerLevel = ArmorCalculator_Options.usePlayerLevel;
		if ( not ArmorCalculator_CleanseDatabase_Base[usePlayerLevel] ) then
			for nameKey, nameValue in pairs(ArmorCalculator_Database_Base) do
				for levelKey, levelValue in pairs(nameValue) do
					if ( type(levelValue) == "table" ) then
						if ( not usePlayerLevel ) then
							nameValue[levelKey] = nil;
						end
					else
						if ( usePlayerLevel ) then
							nameValue[levelKey] = nil;
						end
					end
				end
			end
			ArmorCalculator_CleanseDatabase_Base[usePlayerLevel] = true;
		end
		-- This cleanses the "base" database from entries that are too "far off" 
		-- level-wise. A minor fix allows for more entries to be retained at 
		-- lower levels.
		local cutoff = ArmorCalculator.cutoffLevelDifference;
		if ( cutoff ) and ( cutoff > 0 ) then
			if ( not ArmorCalculator_CleanseDatabase_Cutoff ) 
			or ( ArmorCalculator_CleanseDatabase_Cutoff > cutoff ) then
				local playerLevel = UnitLevel("player");
				if ( playerLevel < 10 ) then
					cutoff = cutoff + ( 10 - playerLevel);
				end
				for nameKey, nameValue in pairs(ArmorCalculator_Database_Base) do
					for levelKey, levelValue in pairs(nameValue) do
						if ( playerLevel - levelKey > cutoff ) or ( levelKey - playerLevel > cutoff ) then
							nameValue[levelKey] = nil;
						end
					end
				end
				ArmorCalculator_CleanseDatabase_Cutoff = cutoff;
			end
		end
	end
	if ( ArmorCalculator_Options.veryStrictMemoryUsage ) then
		local usePlayerLevel = ArmorCalculator_Options.usePlayerLevel;
		for nameKey, nameValue in pairs(ArmorCalculator_Database_User) do
			for levelKey, levelValue in pairs(nameValue) do
				if ( type(levelValue) == "table" ) then
					if ( not usePlayerLevel ) then
						nameValue[levelKey] = nil;
					end
				else
					if ( usePlayerLevel ) then
						nameValue[levelKey] = nil;
					end
				end
			end
		end
	end
end

--- Retrieves raw data from a certain array about a certain entry (name & level)
-- This function is more for internal use.
-- @param db The database array to use
-- @param name The name of the mob to retrieve data about.
-- @param level The level of the particular mob
-- @return the raw data or nil if no such entry exists.
-- @usage for internal use only
function ArmorCalculator_GetDatabaseEntry(db, name, level)
	local arr = db[name];
	if ( not arr ) then
		return nil;
	end
	arr = arr[level]
	if ( not arr ) then
		return nil;
	end
	if ( ArmorCalculator_Options.usePlayerLevel ) then
		local playerLevel = UnitLevel("player");
		arr = arr[playerLevel];
	end
	return arr;
end

--- Retrieves raw data about a certain entry (name & level)
-- This function is more for internal use.
-- @param name The name of the mob to retrieve data about.
-- @param level The level of the particular mob
-- @param database Whether to use user data ("user"), base data ("base") or both ("both" or nil)
-- @return the raw data or nil if no such entry exists.
function ArmorCalculator_GetEntry(name, level, database)
	local base = nil;
	local user = nil;
	if ( not database ) or ( database == "both" ) or ( database == "base" ) then
		base = ArmorCalculator_GetDatabaseEntry(ArmorCalculator_Database_Base, name, level);
	end
	if ( not database ) or ( database == "both" ) or ( database == "user" ) then
		user = ArmorCalculator_GetDatabaseEntry(ArmorCalculator_Database_User, name, level);
	end
	local arr = nil;
	if ( base ) or ( user ) then 
		arr = { 
			a = 0; 
			d = 0; 
			n = 0; 
		};
		if ( base ) then
			if ( base.a ) then
				arr.a = arr.a + base.a;
			end
			if ( base.d ) then
				arr.d = arr.d + base.d;
			end
			if ( base.n ) then
				arr.n = arr.n + base.n;
			end
		end
		if ( user ) then
			if ( user.a ) then
				arr.a = arr.a + user.a;
			end
			if ( user.d ) then
				arr.d = arr.d + user.d;
			end
			if ( user.n ) then
				arr.n = arr.n + user.n;
			end
		end
	end
	return arr;
end

--- Retrieves the damage reduction of a certain entry (name & level)
-- This function is for "public" use.
-- @param name The name of the mob to retrieve data about.
-- @param level The level of the particular mob
-- @return the damage reduction (should be between 0 to 1), the number of datapoints or nil if entry is not present
function ArmorCalculator_GetDamageReduction(name, level)
	local entry = ArmorCalculator_GetEntry(name, level);
	if ( not entry ) then
		return nil;
	end
	if ( not entry.n ) or ( not entry.a ) or ( not entry.d ) or ( entry.n <= 0 ) then
		return nil;
	end
	return ( ( entry.d / entry.a ) / entry.n), entry.n;
end


--- Adds a datapoint to the user database.
-- The "base" database is defined in code form.
-- @param name The name of the mob to retrieve data about.
-- @param level The level of the particular mob
-- @param averageDamage The average amount of damage the attack should do
-- @param damage The amount of damage that the attack did.
-- @return true if the datapoint was added, otherwise false
function ArmorCalculator_AddData(name, level, averageDamage, damage)
	if ( ArmorCalculator_Options.cutoffLevelDifference ) and ( ArmorCalculator_Options.cutoffLevelDifference > 0 ) then
		local playerLevel = UnitLevel("player");
		if ( playerLevel - level > ArmorCalculator_Options.cutoffLevelDifference ) then
			return false;
		end
		if ( level - playerLevel > ArmorCalculator_Options.cutoffLevelDifference ) then
			return false;
		end
	end
	if ( not ArmorCalculator_Database_User[name] ) then
		ArmorCalculator_Database_User[name] = {};
	end
	if ( not ArmorCalculator_Database_User[name][level] ) then
		ArmorCalculator_Database_User[name][level] = {};
	end
	local arr = nil;
	if ( ArmorCalculator_Options.usePlayerLevel ) then
		local playerLevel = UnitLevel("player");
		if ( not ArmorCalculator_Database_User[name][level][playerLevel] ) then
			ArmorCalculator_Database_User[name][level][playerLevel] = {};
		end
		arr = ArmorCalculator_Database_User[name][level][playerLevel];
	else
		arr = ArmorCalculator_Database_User[name][level];
	end
	if ( not arr.a ) then
		arr.a = averageDamage;
	else
		arr.a = arr.a + averageDamage;
	end
	if ( not arr.d ) then
		arr.d = damage;
	else
		arr.d = arr.d + damage;
	end
	if ( not arr.n ) then
		arr.n = 1;
	else
		arr.n = arr.n + 1;
	end
	return true;
end

