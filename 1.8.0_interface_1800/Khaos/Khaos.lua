--[[
--	Khaos
--	 	"Change."
--	
--	By: Alexander Brazie
--	
--	Khaos is an addon which allows for many configurations to be stored and modified. 
--	
--	$Id: Khaos.lua 2684 2005-10-22 23:03:33Z mugendai $
--	$Rev: 2684 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-10-22 18:03:33 -0500 (Sat, 22 Oct 2005) $
--
--	Syntax: 
--		Live Configuration - the in-game running configuration. 
--		Active Configuration - the configuration currently displayed in the gui
--		Inactive Configuration - any configuration not being used 
--		Undead Configuration - a configuration due to prior state and not the settings of the current live configuration
--
--		KhaosFolder - top level construct to contain sets of settings from multiple addons
--		KhaosSet - group of settings for a particular purpose or addon
--		KhaosOption - a single setting 
--]]

-- The Khaos Debug Vars
KHAOS_DEBUG = false;
K_DEBUG = "KHAOS_DEBUG";
KHAOS_DEBUG_VALUE = false;
K_DEBUG_V = "KHAOS_DEBUG_VALUE";

-- Khaos config keywords
K_TEXT = "text";
K_CHECKBOX = "text"; -- Not a typo. Checkboxes use the "text" type to describe their right-side
K_BUTTON = "button";
K_SLIDER = "slider";
K_EDITBOX = "editbox";
K_PULLDOWN = "pulldown";
K_COLORPICKER = "colorpicker";
K_HEADER = "separator";

-- Khaos Valid configs
KHAOS_VALID_TYPES = {
	K_TEXT,
	K_BUTTON,
	K_SLIDER,
	K_EDITBOX,
	K_PULLDOWN,
	K_HEADER
};

-- Globals
KHAOS_VALID_EDITBOX_CALLS = { "tab", "space", "enter", "escape"};
KHAOS_DIFFICULTY_COUNT = 4;
KHAOS_LOAD_COUNT = 3;
KHAOS_CONFIG_HEIGHT = 32;
KHAOS_CONFIG_COUNT = 10;
KHAOS_TOOLTIP_COLOR_STRING = "FFDDDDDD";
KHAOS_TOOLTIP_SUB_COLOR_STRING = "FF666666";
KHAOS_DESCRIPTION_COLOR = {r=156/256,g=212/256,b=256/256};

-- The main external data segment
Khaos_Configurations = {};

-- Mapping of locale->realm->player for configurations
Khaos_Configuration_Locks = {};

-- History of viewed players, etc
Khaos_Configuration_Data = {
	characters = {};
	realms = {};
	classes = {};
};

-- The Actual API
Khaos = {
	--
	-- registerFolder( {KhaosFolder} [, {KhaosFolder}] )
	--	registers a folder or series of folders
	--
	-- args:
	-- 	KhaosFolder - table containing a KhaosFolder description
	--
	registerFolder = function (...)
		for i=1,table.getn(arg) do 
			v = arg[i];
			if ( not KhaosData.configurationFolders[v.id] ) then 
				if ( Khaos.validateFolder(v) ) then 
					KhaosData.configurationFolders[v.id] = v;
				end
			else
				Sea.io.derror(K_DEBUG, "Pre-existing KhaosFolder: ", v.id );
			end
		end
	end;

	--
	-- updateFolder( {KhaosFolder} [, {KhaosFolder} ] )
	--
	-- 	updates the values of an existing KhaosFolder
	--
	updateFolder = function ( ... )
		for i=1,table.getn(arg) do 
			v = arg[i];
			if ( KhaosData.configurationFolders[v.id] ) then 
				if ( Khaos.validateFolder(v) ) then 
					KhaosData.configurationFolders[v.id] = v;
				end
			else
				Sea.io.derror(K_DEBUG, "Non-existing KhaosFolder being updated: ", v.id );
			end
		end
	end;

	--
	-- validateFolder ( folder )
	--
	-- returns:
	-- 	true - valid folder
	-- 	false - invalid folder
	validateFolder = function ( folder ) 
		if ( not folder.id ) then
			Sea.io.error("Khaos.validateFolder: ","Missing folder id to validateFolder from ", this:GetName() );
			return false;
		elseif ( not folder.text ) then 
			Sea.io.error("Khaos.validateFolder: ","Missing text to validateFolder for id ", folder.id, " from ", this:GetName() );
			return false;
		elseif ( not folder.helptext ) then 
			Sea.io.error("Khaos.validateFolder: ","Missing helptext to validateFolder for id ", folder.id, " from ", this:GetName() );
			return false;
		elseif ( not folder.difficulty ) then 
			folder.difficulty = 5;
		end		

		return true;
	end;

	--
	-- unregisterFolder ( folderid )
	-- 	Yikes! You want to nuke an entire folder of configurations?
	-- 	Are you nuts? Well, okay!
	--
	-- args:
	-- 	folderid - string id of the folder
	--
	unregisterFolder = function ( folderid )
		KhaosData.configurationFolders[folderid] = nil;		
	end;

	--
	-- registerOptionSet ( folder, {KhaosSet}  ) 
	-- 	registers an option set and places it within the specified folder.
	--
	-- 	If no folder is specified, then the option set is placed in the "other" folder.
	--
	-- args:
	-- 	folder - (optional) string - the folder id
	-- 	set - a {KhaosSet}
	--
	-- returns: 
	-- 	true - success
	-- 	false - failed to register all safely
	-- 	
	registerOptionSet = function ( folder, set )
		if ( type ( folder ) == "table" ) then 
			set = folder;
			folder = "other";
		elseif ( type( folder ) == "nil" ) then 
			folder = "other";
		end
		if ( Khaos.validateOptionSet(set) ) then 
			if ( not KhaosData.configurationFolderSets[folder] ) then
				KhaosData.configurationFolderSets[folder] = {};
			end			

			KhaosData.configurationFolderSets[folder][set.id] = true;
			
			if ( not KhaosData.configurationSets[set.id] ) then 
				KhaosData.configurationSets[set.id] = set;

				if ( set.commands ) then 
					for k,v in set.commands do
						KhaosCore.registerSlashCommand(set.id, v);
					end
				end

				-- Now run the callbacks on that option set to ensure it gets
				-- the latest values, regardless of when they were set.
				if ( KhaosFrame.variablesLoaded ) then 
					KhaosCore.runCallbacks(nil, {set.id});
				end

				return true;
			else 
				Sea.io.error ( "Khaos.registerOptionSet: ", " Set already exists: ", set.id );
				return false;
			end
		else
			return false;
		end
	end;

	--
	-- unregisterOptionSet( setid ) 
	-- 	unregisters an option set
	--
	-- args:
	-- 	setid - string set id
	--
	unregisterOptionSet = function ( setid )
		for folder,v in KhaosData.configurationFolders do 
			if (KhaosData.configurationFolderSets[folder]) then
				-- ### Unregister Slash Commands here in the future!
				KhaosData.configurationFolderSets[folder][setid] = nil;
			end
		end
		KhaosData.configurationSets[setid] = nil;
		if ( KhaosCore.getCurrentSet() == setid ) then
			KhaosCore.setCurrentSet(nil);
		end
	end;

	--
	-- validateOptionSet ( set ) 
	-- 	Validates a {KhaosSet}
	--
	-- args:
	-- 	set - the KhaosSet to be checked
	--
	-- returns: 
	-- 	true - valid
	-- 	false - invalid
	validateOptionSet = function ( set ) 
		if ( not set.id ) then 
			Sea.io.error("Khaos.validateOptionSet: ", "Missing id for KhaosSet sent to validateOptionSet from ", this:GetName() );
			return false;
		elseif ( not set.text ) then
			Sea.io.error("Khaos.validateOptionSet: ","Missing text for KhaosSet ", set.id, " sent from ", this:GetName() );
			return false;
		elseif ( not set.helptext ) then
			Sea.io.error("Khaos.validateOptionSet: ","No help text for KhaosSet ", set.id, " which would help new users out a lot! ", this:GetName() );
			return false;
		elseif ( set.callback and type(set.callback) ~= "function" ) then
			Sea.io.error("Khaos.validateOptionSet: ","The enable/disable callback was not a function or nil for KhaosSet ", set.id, " creating one will let you know when a set is enabled/disabled.", this:GetName() );
			return false;
		end
		if ( not set.difficulty ) then
			set.difficulty = 2;			
		end
		if ( not set.default ) then
			set.default = false;			
		else
			set.default = true;
		end

		if ( set.options ) then 
			for k,v in set.options do 
				if ( not Khaos.validateOption ( v, set.difficulty ) ) then 
					Sea.io.error ("Khaos.validateOptionSet: ","Unable to validate set due to KhaosOption ", k, " in ", set.id);
					return false;
				end
			end
		end

		if ( set.commands ) then 
			for k,v in set.commands do 
				if ( not Khaos.validateKhaosSlashCommand( v ) ) then 
					Sea.io.error ("Khaos.validateOptionSet: ","Unable to validate set due to KhaosSlashCommand ", k, " in ", set.id);
					return false;
				end
			end
		end

		return true;		
	end;

	--
	-- validateOption ( option )
	-- 	Validates a {KhaosOption}
	--
	-- args:
	-- 	option - the KhaosOption which will be inspected
	--
	-- returns:
	-- 	true - option is OK
	-- 	false - option is missing something...
	--
	validateOption = function ( option, defaultDifficulty ) 
		if ( not option.id ) then
			Sea.io.error ( "Khaos.validateOption: ", "Missing \"id\" from ", this:GetName() );
			return false;
		elseif ( not option.text ) then
			Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " needs a \"text\" describing the option! (from ", this:GetName() , ")");
			return false;
		elseif ( not option.helptext ) then
			Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " needs a \"helptext\" describing the option in detail! (from ", this:GetName() , ")");
			return false;
		elseif ( not option.type ) then 
			option.type = K_TEXT;
		elseif ( type(option.type) ~= "string" ) then
			Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a \"type\" string to specify the kind of option. (from ", this:GetName() , ")");
			return false;
		end

		-- Default the difficulty
		if ( not option.difficulty ) then
			if ( defaultDifficulty ) then 
				option.difficulty = defaultDifficulty;
			else
				option.difficulty = 2;
			end
		end

		-- Check the radio/checkboxes
		if ( option.radio or option.check ) then 
			if ( type( option.callback ) ~= "function" ) then 
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a \"callback\" function which will be called when the checkbox or radio is pushed. (from ", this:GetName() , ")");
				return false;
			elseif ( not option.default ) then
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a default table of properties. (from ", this:GetName() , ")");
				return false;
			end
		end

		-- If its a checkbox type, then key is not important
		if ( option.check ) then 
			if ( not option.key ) then 
				option.key = option.id;
			end

		-- Radios require key values!
		elseif ( option.radio ) then
			if ( not option.key ) then 
				Sea.io.error ( "Khaos.validateOption: ", "Missing \"key\", which is required for radio types to describe the data stored for id ", option.id, " from ", this:GetName() );
				return false;
			end
			if ( not option.value ) then
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " needs a value associated with it for radio types! (from ", this:GetName() , ")");
				return false;				
			end
			
		end
		
		-- Check specific types
		if ( option.type == K_TEXT ) then 
			-- Text requires nothing
		elseif ( option.type == K_BUTTON ) then 
			if ( type( option.callback ) ~= "function" ) then 
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a callback function which will be called when the button is pushed. (from ", this:GetName() , ")");
				return false;
			end
			if ( type( option.setup ) ~= "table" ) then 
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a setup table which contains the \"buttonText\" element. (from ", this:GetName() , ")");
				return false;
			elseif ( type( option.setup.buttonText ) ~= "string" ) then
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " is missing the \"buttonText\" element in its setup table. (from ", this:GetName() , ")");
				return false;				
			end
		elseif ( option.type == K_SLIDER ) then 
			if ( not option.key ) then 
				option.key = option.id;
				
				--Sea.io.error ( "Khaos.validateOption: ", "Missing key to describe the data stored for id ", option.id, " from ", this:GetName() );
				--return false;
			end
			if ( type( option.callback ) ~= "function" ) then 
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a callback function which will be called when the slider is moved. (from ", this:GetName() , ")");
				return false;
			elseif ( not option.default ) then
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a default table of properties. (from ", this:GetName() , ")");
				return false;
			elseif ( not option.disabled ) then
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a disabled table of properties to be used when the set is disabled. (from ", this:GetName() , ")");
				return false;
			end
			if ( type ( option.setup ) ~= "table" ) then 
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a setup table to describe the min, max and step of the slider. (from ", this:GetName() , ")");
				return false;
			else
				if ( not option.setup.sliderMin ) then 
					Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " recommends that the setup table have a sliderMin value to specify the minimum value of the slider. (from ", this:GetName() , ")");
					option.setup.sliderMin = 0;
				end
				if ( not option.setup.sliderMax ) then 
					Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " recommends that the setup table have a sliderMax value to specify the maximum value of the slider. (from ", this:GetName() , ")");
					option.setup.sliderMax = 1;
				end
				if ( not option.setup.sliderStep ) then 
					Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " recommends that the setup table have a sliderStep value to specify the increments of the slider. (from ", this:GetName() , ")");
					option.setup.sliderStep = .1;
				end
				if ( not option.setup.sliderSignificantDigits ) then 
					--Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " recommends that the setup table have a sliderStep value to specify the increments of the slider. (from ", this:GetName() , ")");
					option.setup.sliderSignificantDigits = 3;
				end
				if ( option.setup.sliderDisplayFunc and type ( option.setup.sliderDisplayFunc ) ~= "function" ) then
					Sea.io.derror ( K_DEBUG, "Khaos.validateOption: ", "id ", option.id, " needs to have a function as the sliderDisplayFunc in setup. This will return the slider bar text. (from ", this:GetName() , ")");
					option.setup.sliderDisplayFunc = function ( value ) return value; end;
				end
					
			end
			
		elseif ( option.type == K_EDITBOX ) then 
			if ( not option.key ) then 
				option.key = option.id;
				--Sea.io.error ( "Khaos.validateOption: ", "Missing key to describe the data stored for id ", option.id, " from ", this:GetName() );
				--return false;
			end
			if ( not option.default ) then
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a default table of properties. (from ", this:GetName() , ")");
				return false;
			elseif ( not option.disabled ) then
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a disabled table of properties to be used when the set is disabled. (from ", this:GetName() , ")");
				return false;
			elseif ( type( option.callback ) ~= "function" ) then 
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a callback function which will be called when the editbox callOn events occur. (from ", this:GetName() , ")");
				return false;
			end			
			if ( type ( option.setup ) ~= "table" ) then 
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a setup table with a callOn table to describe when the edit box function will be fired. (from ", this:GetName() , ")");
				return false;
			else
				if ( type( option.setup.callOn ) ~= "table" ) then
					Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " is an editbox, requiring a setup table with a .callOn value to say when to call the Editbox function. (from ", this:GetName() , ")");
					return false;
				else
					for k,v in option.setup.callOn do 
						if ( not Sea.list.isInList(KHAOS_VALID_EDITBOX_CALLS, v ) ) then
							Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " was given an invalid .callOn value of ", v, " (from ", this:GetName() , ")");
							return false;
						end
					end
				end
			end
		elseif ( option.type == K_PULLDOWN ) then 
			if ( not option.key ) then 
				option.key = option.id;
				--Sea.io.error ( "Khaos.validateOption: ", "Missing key to describe the data stored for id ", option.id, " from ", this:GetName() );
				--return false;
			end
			if ( not option.default ) then
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a default table of properties. (from ", this:GetName() , ")");
				return false;
			elseif ( not option.disabled ) then
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a disabled table of properties to be used when the set is disabled. (from ", this:GetName() , ")");
				return false;
			elseif ( type( option.callback ) ~= "function" ) then 
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a callback function which will be called when selection menu is checked/unchecked. (from ", this:GetName() , ")");
				return false;
			end
			if ( type ( option.setup ) ~= "table" ) then 
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a setup table to specify the .options and the multiSelect if multiple values can be chosen. (from ", this:GetName() , ")");
				return false;
			else
				if ( type ( option.setup.options ) ~= "table" and type ( option.setup.options ) ~= "function"  ) then 
					Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a setup table to specify the .options property to specify what options exist. This can be either a function which returns a key-value table or a key-value table (from ", this:GetName() , ")");
					return false;
				elseif ( type ( option.setup.multiSelect ) ~= "boolean" ) then 
					option.setup.multiSelect = false;					
					Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " recommends the setup table to specify the multiSelect property to indicate how many values can be checked. (from ", this:GetName() , ")");
				end				
			end
		elseif ( option.type == K_HEADER ) then
		else
			if ( not option.key ) then 
				option.key = option.id;
			end			
		end

		if ( option.type ~= K_HEADER and option.type ~= K_BUTTON and (option.type == K_TEXT and (option.radio or option.check) ) ) then 
			if ( type(option.feedback) ~= "function" ) then
				if ( this ) then 
					Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a \"feedback\" function that returns a string describing the state of the option. (from ", this:GetName() , ")");
				else
					Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires a \"feedback\" function that returns a string describing the state of the option. (from ", "No Frame Specified. Probably in the .lua file" , ")");
				end
				return false;
			end
		end	

		if ( option.dependencies and type(option.dependencies) ~= "table" ) then 
				Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires the .dependencies value to be a table. (from ", this:GetName() , ")");
				return false;			
		elseif ( option.dependencies ) then 
			for k,v in option.dependencies do 
				if ( not v.value and v.checked == nil ) then 
					Sea.io.error ( "Khaos.validateOption: ", "id ", option.id, " requires that the dependency ", k, " specify the value it depends upon. (from ", this:GetName() , ")");
					return false;
				end
				if ( not v.match ) then
					v.match = true;
				end
			end
		end

		return true;
	end;
	
	--
	-- validateKhaosSlashCommand ( {KhaosSlashCommand} ) 
	--
	-- 	Validates a single slash command which is designed to
	-- 	easily update the Khaos config screen
	--
	-- returns: 
	-- 	true - valid
	-- 	false - invalid
	-- 	
	validateKhaosSlashCommand = function ( slashCommand ) 
		if ( not slashCommand.commands ) then
			Sea.io.error ( "Khaos.validateKhaosSlashCommand: ", "Missing \"commands\" from ", this:GetName() );
			return false;
		elseif ( not slashCommand.parseTree ) then 
			Sea.io.error ( "Khaos.validateKhaosSlashCommand: ", "Missing \"parseTree\" from ", this:GetName() );
			return false;
		end

		return true;
	end;
	
	-- 
	-- registerConfigurationLoadNotice ( {LoadUpdate}, {LoadUpdate} )
	--
	-- 	Registers a callback who will be notified after the registered globals 
	-- 	have been loaded
	--
	-- args: 
	-- 	Many Zig. Examine description of a Zig.
	--
	-- returns:
	-- 	true - all suceeded
	-- 	false - one or more failed
	-- 
	registerConfigurationLoadNotice = function ( ... ) 
		local success = true;
		for k,zig in arg do 
			if ( type(zig) == "table" ) then 
				if ( not zig.id ) then 
					Sea.io.error("Missing id for Zig from ", this:GetName() );
					success = false;
				else
					if ( KhaosData.allZig[zig.id] ) then 
						Sea.io.error("Duplicate Zig id: ", zig.id, " from ", this:GetName() );
						success = false
					elseif ( type(zig.onConfigurationChange ) ~= "function" ) then 
						Sea.io.error("Invalid onConfigurationChange for Zig ", zig.id, " from ", this:GetName() ); 
						success = false;
					elseif ( type(zig.description) ~= "string" ) then 
						Sea.io.error("Missing or invalid description for Zig ", zig.id, " frome ", this:GetName() );
						success = false;
					else
						KhaosData.allZig[zig.id] = zig;
					end
				end
			end
		end
		return success;
	end;

	--
	-- unregisterConfigurationLoadNotice ( id ) 
	-- 	
	-- 	Removes the LoadNotice associated with the id. 
	--
	-- args:
	-- 	id - string id for that LoadNotice
	--
	unregisterConfigurationLoadNotice = function ( id ) 
		KhaosData.allZig[id] = nil;
	end;

	--
	-- registerGlobal ( globalString [, globalString, ... ] )
	-- 	registers a global to be tracked by the Khaos configuration system. 
	-- 	If you want to know when the global has been changed by Khaos, 
	-- 	register a Zig. 
	--
	-- 	It is recommended that you register tables. Tables will be automatically
	-- 	Synchronized if you change them when the Khaos config screen is updated.
	--
	-- Args:
	-- 	globalString - name of the global. E.g. "MyGlobal" will be save MyGlobal. 
	--
	-- Returns:
	-- 	true - no problems
	-- 	false - some sort of error occured
	--
	registerGlobal = function ( ... ) 
		for k,v in arg do
			-- Assign an auto-updating metatable for this global
			if ( type ( getglobal(v) ) == "table" ) then 
				local myName = v;
				local mt = {
					__newindex = function ( table, key, value ) 
						rawset(table, key, value);
						Khaos.updateGlobal(myName);
					end;
				};
				setmetatable(getglobal(v), mt);
			end
			
			KhaosData.monitoredGlobals[v] = true;
		end
	end;

	--
	-- unregisterGlobal ( globalString ) 
	-- 	removes a global from the registration. 
	-- 	If unregistered, a global will no longer be populated, 
	-- 	though its value will continue to be stored in configurations. 
	--
	-- Args:
	-- 	globalString - the name of the global
	--
	unregisterGlobal = function ( globalString ) 
		KhaosData.monitoredGlobals[globalString] = nil;
	end;

	--
	-- updateGlobal ( globalString [, globalString, ... ] ) 
	-- 	Tells Khaos to update the value of the global in the live configuration
	--
	-- args:
	-- 	globalString - string - name of the global 
	--
	updateGlobal = function ( ... )  	
		for k,v in arg do 
			Khaos.setSetKey( "custom",  v, getglobal(v) );
		end;
	end;

	
	--
	-- getSetKey( set, key)
	-- 	Gets the value of a specified set/key
	--
	-- Args:
	-- 	set - the string setid
	-- 	key - the key's id
	-- 
	-- Returns:
	-- 	value - {KhaosKey}
	-- 
	getSetKey = function ( set, key ) 
		if ( not set ) then 
			Sea.io.error("Invalid set (nil) sent to Khaos.getSetKey from ", this:GetName() );
			return;
		elseif ( not key ) then 
			Sea.io.error("Invalid key (nil) sent to Khaos.getSetKey from ", this:GetName() );			
			return;
		end

		-- Check if there's a value in memory
		local id = KhaosCore.getActiveConfigurationID();
		local cfg = KhaosCore.getConfiguration(id);

		return KhaosCore.getSetKeyFromConfig(cfg, set, key);
	end;

	--
	-- updateSetKeys ( set, keylist, replace ) 
	--	Updates each of the keys in a set with the values. 
	--
	--	Also updates the gui if its open.
	--
	-- Args:
	-- 	set - set string id
	-- 	keylist - the list of key-value for replacement in the current configuration
	-- 	replace 
	-- 		true - overwrite the keys
	-- 		false/nil - only overwrite keys explicitly stated
	--
	updateSetKeys = function ( set, keylist, replace ) 
		if ( not set ) then 
			Sea.io.error("Invalid set (nil) sent to Khaos.updateSetKeys from ", this:GetName() );
			return;
		elseif ( not keylist ) then
			Sea.io.error("Invalid keylist (nil) sent to Khaos.updateSetKeys from ", this:GetName() );
			return;
		end

		local id = KhaosCore.getActiveConfigurationID();
		local cfg = KhaosCore.getConfiguration(id);

		for k,v in keylist do 
			if ( replace ) then 
				KhaosCore.setSetKey(set, k, v);
			else
				for k2,v2 in v do 
					Khaos.setSetKeyParameter(set, k, k2, v2);
				end
			end
		end

		if ( KhaosFrame:IsVisible() ) then 
			if ( KhaosCore.getCurrentSet() == set ) then 
				Khaos.refresh()
			end
		end
	end;
	
	--
	-- setSetKey( set, key, value )
	-- 	Set the value of the whole set's key
	--
	-- Args:
	-- 	set - set string id
	-- 	key - set value key
	-- 	value - set value table
	-- 
	setSetKey = function ( set, key, value )
		if ( not set ) then 
			Sea.io.error("Invalid set (nil) sent to Khaos.setSetKey from ", this:GetName() );
			return;
		elseif ( not key ) then 
			Sea.io.error("Invalid key (nil) sent to Khaos.setSetKey from ", this:GetName() );			
			return;
		end

		local id = KhaosCore.getActiveConfigurationID();
		local cfg = KhaosCore.getConfiguration(id);

		return KhaosCore.setSetKeyFromConfig(cfg, set, key, value);		
	end;
	
	-- setSetKeyParameter( set, key, parameter, value ) 
	-- 	Sets the value of a set key's parameter
	--
	-- Args:
	-- 	set - string set id
	-- 	key - string key id 
	-- 	parameter - string parameter name
	-- 	value - new parameter value
	-- 	
	setSetKeyParameter = function ( set, key, parameter, value ) 
		if ( not set ) then 
			Sea.io.error("Invalid set (nil) sent to Khaos.setSetKey from ", this:GetName() );
			return;
		elseif ( not key ) then 
			Sea.io.error("Invalid key (nil) sent to Khaos.setSetKey from ", this:GetName() );			
			return;
		end

		local v = Khaos.getSetKey(set, key);
		if (not v) then 
			Sea.io.error("Invalid set/key pair (Set: ", set, " Key: ", key, ") sent to Khaos.setSetKey from ", this:GetName() );
		end
		v[parameter] = value;
		
		local id = KhaosCore.getActiveConfigurationID();
		local cfg = KhaosCore.getConfiguration(id);

		KhaosCore.setSetKeyFromConfig(cfg, set, key, v);
	end;

	--
	-- setSetEnabled( set, enabled )
	-- 	Enables or disables a set in the current configuration
	--
	-- args:
	-- 	set - string set id
	-- 	enabled - true or false
	--
	setSetEnabled = function ( set, enabled )
		Sea.io.dprint(K_DEBUG, "Setting set ", set, " enable to ", enabled);
		Khaos.setSetKey("sets", set, enabled);
		KhaosCore.runCallbacks();
	end;

	-- 
	-- getSetEnabled( set )
	-- 	Returns the enabled state of a set
	--
	-- args:
	-- 	set - the set ID 
	--
	-- return:
	-- 	true - set is enabled
	-- 	false - set is disabled
	-- 	
	getSetEnabled = function (setid)	
		local enabled = Khaos.getSetKey("sets", setid);

		if ( type(enabled) == "nil" ) then 
			local default =  KhaosData.configurationSets[setid].default;
			if ( default ~= nil ) then 
				Khaos.setSetKey("sets", setid, default );
			else
				Khaos.setSetKey("sets", setid, false );
			end
			enabled = Khaos.getSetKey("sets", setid);
		end

		return enabled;
	end;
	
	--
	-- checkSetKey( set, key, parameter, expected ) 
	-- 	Checks to see if a key is the value being tested against
	--
	-- Args:
	-- 	set - string set id
	-- 	key - string key id
	-- 	parameter - string parameter id
	-- 	expected - expected value of the key
	-- 	
	checkSetKey = function ( set, key, parameter, expected ) 
		local value = Khaos.getSetKey(set, key);

		if ( value ) then 
			if ( value[parameter] ) then 
				if (value[parameter] == expected ) then
					return true;
				else
					return false;
				end
			end
		end
	end;

	--
	-- refresh (config, set, option) 
	--	Refreshes the gui on demand
	--
	-- args: 
	-- 	if no args, everything updates
	-- 	
	-- 	config - refresh the config pane
	-- 	set - refresh the set pane
	-- 	option - refresh the option pane
	--
	refresh = function (config, set, option)
		if ( not config and not set and not option ) then 
			KhaosConfig_UpdateConfigurationPane ()
			KhaosConfig_UpdateSetPane()
			KhaosConfig_UpdateOptionPane();	
		else
			if ( config ) then 
				KhaosConfig_UpdateConfigurationPane ()
			end
			if ( set ) then 
				KhaosConfig_UpdateSetPane();
			end
			if ( option ) then 
				KhaosConfig_UpdateOptionPane();
			end
		end
	end;
};

-- Holds internal functions (not for general use)
KhaosCore = {
	-- Creates a new configuration
	--
	-- returns: 
	-- 	id - id of the new config
	-- 
	createConfiguration = function (name, keywords)
		if ( not name or name == "" ) then
			name = "New Configuration";
		end
		local config = {};

		config.name = name; 
		config.keywords = {};
		config.configuration = {};
		config.configuration.sets = {};
		config.configuration.custom = {};

		if ( keywords ) then 
			for k,v in keywords do 
				config.keywords[k] = v;
			end
		end

		-- Populate with default data
		for setid,set in KhaosData.configurationSets do 
			if ( not config.configuration[setid] ) then 
				config.configuration[setid] = {};
			end

			config.configuration.sets[setid] = set.default;

			for k,option in set.options do
				if ( option.key ) then 
					config.configuration[setid][option.key] = Sea.table.copy(option.default);
				end
			end
		end

		local id = KhaosCore.insertConfiguration(config);
		
		return id;
	end;

	-- Deletes the configuration 
	deleteConfiguration = function ( id ) 
		table.remove(Khaos_Configurations, id);
	end;

	-- Inserts the configuration to the end and returns an id
	insertConfiguration = function ( config )
		local id = table.getn(Khaos_Configurations);
		if ( not id ) then 
			id = 0;
		end
		id = id + 1;

		if ( not Khaos_Configurations[id] ) then 
			Khaos_Configurations[id] = config;
		else
			table.insert(Khaos_Configurations, config);
			id = table.getn(Khaos_Configurations);
		end

		return id;
	end;

	-- Gets the configuration id in editor memory
	getActiveConfigurationID = function () 
		if ( KhaosData.activeConfiguration and Khaos_Configurations [ KhaosData.activeConfiguration ] ) then 
			return KhaosData.activeConfiguration; 
		else
			return KhaosCore.getLiveConfigurationID();
		end
	end;

	-- Gets the current configuration the game is rendering
	getLiveConfigurationID = function () 
		if ( Khaos_Configurations [ KhaosData.liveConfiguration ] ) then 
			return KhaosData.liveConfiguration; 
		else
			return KhaosCore.getDefaultConfigurationID();
		end
	end;

	-- Gets the default configuration id
	getDefaultConfigurationID = function()
		local default = nil;
		for k,v in Khaos_Configurations do 
			if ( v.keywords.default ) then 
				default = k;
			end
		end

		--[[
		--I do not remember why this code is here, so I am commenting it out for the moment. 
		if ( default == nil ) then 
			-- Create a new default configuration
			default = KhaosCore.createConfiguration(KHAOS_DEFAULT_CONFIGURATION_NAME, {default=true});
			local id = KhaosCore.copyConfiguration(1);

			Khaos_Configurations[id].name=KHAOS_EMPTY_CONFIGURATION_NAME;
			for k,v in Khaos_Configurations[id].configuration.sets do 
					Khaos_Configurations[id].configuration.sets[k] = false;
			end
		end
		]]

		return default;
	end;

	-- Gets the configuration by ID
	getConfiguration = function ( id ) 
		if ( Khaos_Configurations[id] ) then
			return Khaos_Configurations[id];
		end;
	end;

	-- Copies the configuration matching the id
	-- returns the id for the new config
	copyConfiguration = function ( id ) 
		local orig = KhaosCore.getConfiguration(id);
		if ( not orig ) then 
			orig = getConfiguration(KhaosCore.getActiveConfigurationID());
		end
		
		-- Copy
		local newCfg = Sea.table.copy(orig);
		
		-- Rename
		newCfg.name = newCfg.name..KHAOS_DEFAULT_COPY_APPEND;

		-- Add
		local newid = KhaosCore.insertConfiguration(newCfg);

		return newid;
	end;

	--
	-- Checks to ensure a configuration is valid
	checkConfiguration = function ( id )
		if ( type ( Khaos_Configurations[id] ) == "table" ) then
			if ( type(Khaos_Configurations[id].name) ~= "string"  ) then 
				Sea.io.derror(K_DEBUG, "Invalid configuration missing name property. ID was ", id, " from ", this:GetName() );
				return false;
			elseif ( type(Khaos_Configurations[id].keywords) ~= "table"  ) then 
				Sea.io.derror(K_DEBUG, "Invalid configuration missing keywords property. ID was ", id, " named ", Khaos_Configurations[id].name , " from ", this:GetName() );
				return false;
			else
				return true;
			end
		else
			return false;
		end
	end;

	--
	-- Loads a configuration into live space
	-- 
	loadConfiguration = function ( id )
		if ( not KhaosCore.checkConfiguration ( id ) ) then
			return; 
		end

		Sea.io.dprint(K_DEBUG, "Loading configuration ", id );

		local cfg = KhaosCore.getConfiguration(id);
		KhaosData.activeConfiguration = id;

		-- Copy the configuration
		KhaosData.oldConfiguration = Sea.table.copy(cfg.configuration); 

		-- Update all callbacks
		KhaosCore.runCallbacks(cfg);
		
		-- Update all globals
		if ( cfg.configuration ) then
			if ( cfg.configuration.custom ) then 
				for k,v in cfg.configuration.custom do 
					if ( KhaosData.monitoredGlobals[k] ) then 
						setglobal( k, v );
					end
				end
			end
		end

		-- Notify Zig
		KhaosCore.notifyZig();
		
	end;

	--
	-- Saves the configuration 
	--
	saveConfiguration = function ()
		Sea.io.dprint(K_DEBUG, "Saving configuration ", KhaosCore.getLiveConfigurationID() );
		
		-- Copy the configuration from memory to storage
		local cfg = KhaosCore.getConfiguration(KhaosCore.getActiveConfigurationID());
		KhaosData.oldConfiguration = nil;

		-- Update all globals (if registered)
		if ( not cfg.configuration ) then
			cfg.configuration = {};
		end
		
		
		if ( not cfg.configuration.custom ) then 
			cfg.configuration.custom = {};
		end
		for k,v in KhaosData.monitoredGlobals do
			cfg.configuration.custom[k] = getglobal( k );
		end
	end;

	--
	-- Keep the active configuration as the live configuration
	keepConfiguration = function () 
		KhaosData.liveConfiguration = KhaosData.activeConfiguration;
	end;

	-- 
	-- Reverts the configuration back to the live setting
	revertConfiguration = function()
		local cfg = KhaosCore.getConfiguration(KhaosCore.getActiveConfigurationID());
		cfg.configuration = KhaosData.oldConfiguration;
		KhaosCore.saveConfiguration();
	end;
	
	--
	-- Runs all of the callback functions for options
	runCallbacks = function ( cfg, setlist )
		if ( not cfg ) then 
			cfg = KhaosCore.getConfiguration(KhaosCore.getActiveConfigurationID());
		end
			
		local called = {};
		local sets = {};
		if ( not setlist ) then 
			sets = KhaosData.configurationSets;
		else
			for k,v in setlist do 
				sets[v]=KhaosData.configurationSets[v];
			end
		end
		
		-- Loop through all configuration data
		for setid,set in sets do

			local setDisabled = not( KhaosCore.getSetKeyFromConfig(cfg, "sets", setid) );

			if ( set.callback ) then 
				set.callback( not setDisabled );
			end
			for k,option in set.options do
				local optionDisabled = KhaosConfig_IsOptionDisabled( option, setid, false, cfg);

				if ( option.key ) then 
					local key = KhaosCore.getSetKeyFromConfig(cfg, setid, option.key);
					-- Work first, efficiency later
					--if ( not called[option.key] ) then 
						called[option.key] = true;
						
						if ( setDisabled or optionDisabled ) then 							
							--Sea.io.error("disable", option.id);
							option.callback ( option.disabled );
						elseif ( not key ) then 
							--Sea.io.error("default", option.id);
							option.callback ( option.default );
						else
							option.callback ( key );
						end
					--end
				end
			end
		end

	end;

	--
	-- Notifies register Zig that the globals have been changed
	notifyZig = function () 
		-- Loop through all zig
		for k,zig in KhaosData.allZig do
			if ( type(zig.onConfigurationChange) == "function" ) then 
				zig.onConfigurationChange();
			end
		end
	end;

	-- 
	-- Gets the value of a key from a specific configuration
	getSetKeyFromConfig = function ( config, set, key )
		--Sea.io.dprint(K_DEBUG, "Retrieving the set \"", set, "\"'s key ", key, " from ", config);
		if ( config and config.configuration ) then 
			if ( config.configuration[set] and config.configuration[set][key] ~= nil ) then 
				return config.configuration[set][key];
			else
				if ( KhaosData.configurationSets[set] ) then 
					for k,v in KhaosData.configurationSets[set].options do 
						if ( v.key == key ) then 
							local newKey = Sea.table.copy(v.default);
							if ( not config.configuration[set] ) then 
								config.configuration[set] = {};
							end
							config.configuration[set][key] = newKey;
							return newKey;
						end
					end
				end
			end
		end
		return nil;
	end;

	--
	-- Sets the table associated with a key from a specific configuration
	setSetKeyFromConfig = function ( config, set, key, value )
		--Sea.io.dprint(K_DEBUG, "Setting the set \"", set, "\"'s key ", key, " to ", value, " in ", config.name);
		if ( config and config.configuration ) then 
			if ( not config.configuration[set] ) then 
				config.configuration[set] = {};
			end
			config.configuration[set][key] = value;
			local count = 0;
			local keys = Sea.table.getKeyList(config.configuration[set]);
			if ( keys ) then 
				count = table.getn(keys);
			end
			if ( count == 0 ) then config.configuration[set] = nil; end
		end
	end;

	--
	-- Sets the table parameter associated with a set, config and key
	setSetKeyParameterFromConfig = function( config, set, key, parameter, value )
		--Sea.io.dprint(K_DEBUG, "Setting the set \"", set, "\"'s key ", key, "'s parameter ", parameter, " to ", value);
		if ( config and config.configuration ) then 
			if ( not config.configuration[set] ) then 
				config.configuration[set] = {};
			end
			
			config.configuration[set][key][parameter] = value;
				
			local count = 0;
			local keys = Sea.table.getKeyList(config.configuration[set]);
			if ( keys ) then 
				count = table.getn(keys);
			end
			if ( count == 0 ) then config.configuration[set] = nil; end
		end
	end;

	--
	-- Renames a configuration
	renameConfiguration = function ( id, newname ) 
		local cfg = KhaosCore.getConfiguration(id);
		cfg.name = newname;
	end;

	--
	-- Sets a keyword
	setKeywordByID = function ( id, keyword, value ) 
		local cfg = KhaosCore.getConfiguration(id);
		cfg.keywords[keyword] = value;
	end;

	--
	-- Gets a keyword 
	getKeywordByID = function ( id, keyword ) 
		local cfg = KhaosCore.getConfiguration(id);
		if ( cfg ) then 
			return cfg.keywords[keyword];
		end
	end;

	--
	-- Sets a keyword
	setKeyword = function ( keyword, value ) 
		local id = KhaosCore.getDefaultConfigurationID();
		id = KhaosCore.getActiveConfigurationID();
		KhaosCore.setKeywordByID( id, keyword, value);
	end;

	--
	-- Gets a keyword 
	getKeyword = function ( keyword ) 
		local id = KhaosCore.getDefaultConfigurationID();
		id = KhaosCore.getActiveConfigurationID();
		return KhaosCore.getKeywordByID( id, keyword);		
	end;

	--
	-- Finds a list of suitable matches for the specified keys
	--
	-- Args:
	-- 	Keywords - table of keys
	-- 		player - string - player's name 
	-- 		realm - string - current realm
	-- 		class - string - current class
	--
	-- Returns:
	-- 	Matches - table
	-- 		Each match contains: id and score
	-- 
	matchKeywords = function ( keywords )
		local matches = {};
		
		for i=1,table.getn(Khaos_Configurations) do 
			local score = 0;
			for k,v in keywords do 
				local a = KhaosCore.getKeywordByID(i, k);

				if ( type(a) == "table" ) then 
					if ( Sea.list.isInList(a, v) ) then 
						score = score + 1;
					end
				else
					if ( k == "default" and a ) then
						 score = score + .5;
					end
				end
			end	

			table.insert(matches, {id=i,score=score} );
		end

		table.sort(matches, function(a,b) return a.score > b.score end );

		if ( table.getn(matches) == 0 ) then 
			matches = {{id=1;score=.5}};
		end
		return matches;
	end;

	--
	-- Sets the active difficulty level of Khaos
	-- 	
	-- args:
	-- 	difficulty - number - 1 -> 10  (level of difficulty displayed)
	--
	setDifficulty = function(level)
		if ( type (level) == "number" ) then 
			level = math.floor(level);
			if (level > KHAOS_DIFFICULTY_COUNT) then 
				level = KHAOS_DIFFICULTY_COUNT;
			elseif ( level < 1 ) then
				level = 1;
			end
			KhaosCore.setKeyword("difficulty", level);
		end
	end;

	--
	-- Sets the active offset of Khaos's Option pane
	--
	-- args:
	-- 	offset - number 1 -> N (number of options )
	--
	setOffset = function ( offset ) 
		local max = KhaosConfig_GetOptionCountBySetId( KhaosCore.getCurrentSet() );
	
		if ( offset ) then 
			KhaosData.currentOffset = offset;
	
			if ( KhaosData.currentOffset > max - 9 ) then 
				KhaosData.currentOffset = max - 9;
			end
			if ( KhaosData.currentOffset < 0 ) then 
				KhaosData.currentOffset = 0;
			end
		end
	end;

	--
	-- Gets the difficulty level of Khaos currently
	--
	-- returns:
	-- 	number - level
	-- 	
	getDifficulty = function ()
		local difficulty = KhaosCore.getKeyword("difficulty");

		if ( not difficulty ) then 
			return KhaosData.defaultLevel;
		else
			return difficulty;
		end
	end;

	--
	-- Gets the offset level of Khaos currently
	--
	-- returns:
	-- 	number - level
	-- 	
	getOffset = function ()
		local offset = KhaosData.currentOffset;

		if ( not offset ) then 
			return 0;
		else
			return offset;
		end
	end;

	--
	-- Sets the currently displayed set in the Khaos Config window
	--
	-- args:
	-- 	id - the set id
	--
	setCurrentSet = function(id)
		KhaosData.currentSet = id;
	end;

	--
	-- Gets the currently displayed set
	--
	-- returns:
	-- 	string - the set id
	--
	getCurrentSet = function()
		return KhaosData.currentSet;
	end;

	--
	-- Validates a KhaosSlashCommand
	validateSlashCommand = function ( commandSet )
		if ( not commandSet.id ) then 
			Sea.io.error ( "KhaosCore.validateSlashCommand: ", "Missing \"id\" from ", this:GetName() );
			return false;
		end
		if ( type( commandSet.commands ) ~= "table" ) then 
			Sea.io.error ( "KhaosCore.validateSlashCommand: ", "Missing \"commands\" table from ", this:GetName() );
			return false;
		end
		if ( type( commandSet.parseTree ) ~= "table" ) then 
			Sea.io.error ( "KhaosCore.validateSlashCommand: ", "Missing \"parseTree\" table from ", this:GetName() );
			return false;
		end
		return true;
	end;

	-- 
	-- Registers a KhaosSlashCommand with Sky
	--
	registerSlashCommand = function ( set, commandSet ) 
		local tree = commandSet.parseTree;
		if ( Sky ) then 
			Sea.io.dprint(K_DEBUG, "Registering with Sky, ", commandSet.id);
			if ( KhaosCore.validateSlashCommand ( commandSet ) ) then 
				Sky.registerSlashCommand(
				{
					id=set..commandSet.id;
					commands = commandSet.commands;
					helpText = commandSet.helpText;
					onExecute = function(msg, cmd) KhaosCore.processSlashCommand(msg, cmd, tree, set); end;
				}
				);
			end
		else
			Sea.io.dprint(K_DEBUG, "Sky was not found.");
		end
	end;
	
	--
	-- Processes a KhaosSlashCommand
	--
	processSlashCommand = function ( msg, cmd, parseTree, set ) 
		local words = Sea.string.split(msg, " ");
		local currentWord = words[1];
		local restOfMessage = ""; 
		
		if ( string.find(msg, " ") ) then 
			local start, finish = string.find(msg, " ");
			restOfMessage = string.sub( msg, start+1 );
		end

		-- Iterate through all actions first
		local i = 1; 
		while ( parseTree[i] ) do
			if ( type(parseTree[i]) == "function" ) then
				parseTree[i].callback(msg, cmd, set);
			else
				if ( type(parseTree[i].key) == "string" ) then 
					if ( type(parseTree[i].stringMap) == "table" ) then 
						-- Default first
						local process = parseTree[i].stringMap.default;
						-- If we have a match
						if ( parseTree[i].stringMap[currentWord] ) then
							process = parseTree[i].stringMap[currentWord];
						end;
						if ( process ) then 
							for k,v in process do 
								if ( type(v) == "string" ) then 
									v = KhaosCore.processEncodedSlashString(v, words, set, parseTree[i].key);
								end
								Khaos.setSetKeyParameter(set, parseTree[i].key, k, v);
							end
						end
					end
					if ( type(parseTree[i].valueMap) == "table" ) then 
						for k,v in parseTree[i].valueMap do 
							if ( type(v) == "string" ) then 
								v = KhaosCore.processEncodedSlashString(v, words, set, parseTree[i].key);
							end
	
							Khaos.setSetKeyParameter(set, parseTree[i].key, k, v);
						end
					end
				end
				if ( type(parseTree[i].callback) == "function" ) then 
					parseTree[i].callback(msg, cmd, set);
				end
			end
			i = i + 1;
		end

		-- Perform callbacks next
		if ( type(parseTree.callback) == "function" ) then 
			parseTree.callback(msg, cmd, set);
		end

		-- Perform subtrees next
		if ( currentWord and parseTree[string.lower(currentWord)] ) then 
			if ( type ( parseTree[string.lower(currentWord)] ) == "table" ) then 
				KhaosCore.processSlashCommand( restOfMessage, cmd, parseTree[string.lower(currentWord)], set );
			elseif ( type ( parseTree[string.lower(currentWord)] ) == "function" ) then
				parseTree[string.lower(currentWord)](msg, cmd, set)
			end
		-- Perform a default if it exists
		elseif ( (not currentWord or currentWord == "" or parseTree[string.lower(currentWord)] == nil ) and parseTree.default ) then 
			if ( type (parseTree.default) == "table" ) then 
				KhaosCore.processSlashCommand( restOfMessage, cmd, parseTree.default, set );
			elseif ( type(parseTree.default) == "function" ) then 
				parseTree.default(msg, cmd, set);
			end
		end

		-- Run the callbacks
		KhaosCore.runCallbacks(nil, {set});

		-- Refresh the UI
		if ( set == KhaosCore.getCurrentSet() ) then 
			Khaos.refresh();
		end
	end;
	
	--
	-- processEncodedSlashString ( msg, words, set, currentKey ) 
	--
	-- This parses the %1s encoded msg and {SomeKey.slider} and 
	-- !SomeKey.checked@ type phrases, then returns the result
	--
	-- if a checked value is just "!", it will negate the checked value in currentKey
	--
	processEncodedSlashString = function ( msg, words, set, currentKey )
		local wordInsert = function( msg, n, t )
			if ( n and words[n] ) then 
				if ( t ) then
					-- If the string consists only of that phrase
					-- Convert it to a decimal or boolean
					if ( string.len(msg) == string.len(tostring(n))+2 ) then 
						if ( t == "d" or t == "n" ) then 
							return tonumber(words[n]);
						elseif ( t == "b" ) then 
							if ( string.lower(words[n]) == "true" ) then 
								return true;
							else
								return false;
							end
						else
							return string.gsub(msg, "%%"..n, words[n]);							
						end
					else
						return string.gsub(msg, "%%"..n..t, words[n]);							
					end
				else
					return string.gsub(msg, "%%"..n, words[n]);
				end
			else 
				if ( n ) then 
					return string.gsub(msg, "%%"..n, "<No Word>");
				else
					return msg;
				end
			end

			return msg;
		end;
		
		-- First, convert the words
		while ( type (msg) == "string" and string.find( msg, "%%%d%w?" ) ) do 
			local first, last = string.find( msg, "%%%d%w?" );
			local w = string.sub( msg, first, last );
			local n = string.gsub(w, "%%(%d)(%w?)","%1");
			local t = string.gsub(w, "%%(%d)(%w?)","%2");

			n = tonumber(n);
			msg = wordInsert(msg, n,t);
		end

		-- Next, convert the keywords in $$
		while ( type (msg) == "string" and string.find( msg, "%b$$" ) ) do 
			local first, last = string.find( msg, "%b$$" );
			local word = string.sub( msg, first, last );
			local realWord = string.sub( msg, first+1, last-1 );
			local data = Sea.string.split(realWord, ".");
			local key = Khaos.getSetKey(set, data[1]);

			if ( first == 1 and string.len(msg) == last ) then 
				msg = key[data[2]];
				break;
			else
				if ( key[data[2]] ) then 
					local replace = tostring(key[data[2]]);
					word = string.gsub(word, "%$", "%%%$");
					msg = string.gsub(msg, word, replace);
				else
					word = string.gsub(word, "%$", "%%%$");
					msg = string.gsub(msg, word, "<no key>");
				end
			end
		end
		
		-- Shortcut for toggles 
		if ( type(msg) == "string" and msg == "!" ) then 
			local key = Khaos.getSetKey(set, currentKey);
			return (not key.checked);
		end

		-- Next, convert the keywords prefixed by ! 
		while ( type (msg) == "string" and string.find( msg, "[%!%~][%.%w]+") ) do 
			local first, last = string.find( msg, "[%!%~][%.%w]+" );
			local word = string.sub( msg, first, last );
			local realWord = string.sub( msg, first+1, last );
			local data = Sea.string.split(realWord, ".");
			local key = Khaos.getSetKey(set, data[1]);

			-- If the length matches, then replace the whole thing!
			if ( first == 1 and string.len(msg) == last ) then 
				msg = not key[data[2]];
				break;
			else
				if ( key[data[2]] ) then 
					word = string.gsub(word, "%!", "%%%!");
					msg = string.gsub(msg, word, tostring(not key[data[2]]));
				else
					word = string.gsub(word, "%!", "%%%!");
					msg = string.gsub(msg, word, "<no key>");
				end
			end
		end

		return msg;
	end;
	
	-- 
	--  resetSet ( setid )
	--
	--  Resets the current set to default
	--
	resetSet = function ( setid )
		--if ( KhaosData.configurationSets[setid] and  KhaosData.configurationSets[setid].options  ) then
			for k,option in KhaosData.configurationSets[setid].options do
					if ( option.key ) then 
						Khaos.setSetKey(setid, option.key, Sea.table.copy(option.default) );
						if ( option.callback ) then
							local optionDisabled = KhaosConfig_IsOptionDisabled( option, setid, true);
	
							if ( optionDisabled ) then 
								option.callback(option.disabled);
							else
								option.callback(option.default);
							end
						end
					end
			end
		--end
	end;

	--
	-- updateKeywords ( realm, character, class, classText )
	-- 	Updates the keywords for all configurations
	-- 	
	updateKeywords = function( realm, character, class, classText )
		local matches = KhaosCore.matchKeywords ( { player = character; realm = realm; class = class } ); 
		local locale = GetLocale();	

		for k,v in Khaos_Configurations do 
			if ( not v.keywords ) then 
				v.keywords = {};
			end
			v.keywords.character = {};
			v.keywords.realm = {};
			v.keywords.class = {};

			local lockedConfig;
			if ( Khaos_Configuration_Locks[locale] ) then 
				if ( Khaos_Configuration_Locks[locale][realm] ) then 
					lockedConfig = Khaos_Configuration_Locks[locale][realm][character];
				end
			end
			
			if ( k == lockedConfig ) then
				v.keywords.default = true;
			elseif ( not lockedConfig and k == matches[1].id ) then
				v.keywords.default = true;
			else
				v.keywords.default = nil;				
			end
		end
		
		-- If a locale entry exists, this implies a realm/character exist, right?
		-- If not, this will need more error checking.
		if ( Khaos_Configuration_Locks[locale] ) then 
			for realm, t1 in Khaos_Configuration_Locks[locale] do 
				for character, id in t1 do
					if ( Khaos_Configurations[id] ) then 
						local k = Khaos_Configurations[id].keywords;
						local class;
						if ( Khaos_Configuration_Data.realms[realm] ) then
							class = Khaos_Configuration_Data.realms[realm][character];
						end
						k.character[character]=character;
						k.realm[realm] = realm;
						if ( class ) then
							k.class[class] = Khaos_Configuration_Data.classes[class];
						end
					else
						t1[character] = nil;
					end
				end
			end	
	
			if ( v.keywords ) then 
				if ( table.getn(v.keywords.character) == 0 ) then 
					v.keywords.character = nil;
				end
	
				if ( table.getn(v.keywords.realm) == 0 ) then 
					v.keywords.realm = nil;
				end

				if ( table.getn(v.keywords.class) == 0 ) then 
					v.keywords.class = nil;
				end
			end
		end
	end;

	-- 
	-- addCharacter ( realm, character, class, classText )
	--
	-- 	Creates mapping of characters->realm->class and realm->character->class
	-- 	Create a mapping of class->localized class name 
	--
	-- 	These are used to generate the keywords for all configurations.
	--
	addCharacter = function ( realm, character, class, classText )
		if ( not Khaos_Configuration_Data.realms[realm] ) then
			Khaos_Configuration_Data.realms[realm] = {};
		end
		
		Khaos_Configuration_Data.realms[realm][character] = class;
		
		if ( not Khaos_Configuration_Data.characters[character] ) then
			Khaos_Configuration_Data.characters[character] = {};
		end

		Khaos_Configuration_Data.characters[character][realm] = class;	
		
		if ( not Khaos_Configuration_Data.classes[class] ) then
			Khaos_Configuration_Data.classes[class] = classText;
		end
	end;


	--[[
	--	loadAddOn(name)
	--	
	--	Load an addon with a nice message and print an error if it does not work.
	--
	--	name - the name of the addon!
	--]]
	loadAddOn = function ( name )
		loaded, reason = LoadAddOn(name);

		if loaded then 
			Sea.io.print(string.format(KHAOS_LOADED_MESSAGE,name));
		else
			Sea.io.print(string.format(KHAOS_NOTLOADED_MESSAGE,name,reason));
		end
	end;
};

-- Holds the actual gui information
KhaosData = {
	-- The active Configuration index
	activeConfiguration = 1;

	-- The old configuration value
	oldConfiguration = nil;

	-- The live Configuration index
	liveConfiguration = 1;

	-- Data about folders used to contain Config Sets
	configurationFolders = {};

	-- Configuration set locations
	configurationFolderSets = {};

	-- Configuration set data
	configurationSets = {};

	-- Zig are bots that give you info about when the global config has changed
	allZig = {};

	-- Monitored globals are globals that will be stored and changed based on the selected configuration
	monitoredGlobals = {};

	-- Default difficulty
	defaultLevel = 1;

	-- Currently open Configuration Set
	currentSet = nil;

	-- Current offset for the Configuration Change pane
	currentOffset = 0;

	-- Currently drawing control value
	configurationDrawing = 0;

	-- The value to surpress Enters (to keep feedback shown)
	surpressId = -1;
};

Khaos_Select_Groups = {
	{
		label = KHAOS_SELECT_ALL;
		header = KHAOS_SELECT_ALL_HEADER;
		texture = "Interface\\AddOns\\Khaos\\Skin\\UI-MicroButton-Brain-Up";
		keywords = { "all" };
	};
	{
		label = KHAOS_SELECT_CHARACTERS;
		header = KHAOS_SELECT_CHARACTERS_HEADER;
		texture = "#Player#";
		keywords = { "character" };
	};
	{
		label = KHAOS_SELECT_REALMS;
		header = KHAOS_SELECT_REALMS_HEADER;
		texture = "Interface\\Buttons\\UI-MicroButton-World-Up";
		keywords = { "realm" };
	};
	{
		label = KHAOS_SELECT_CLASSES;
		header = KHAOS_SELECT_CLASSES_HEADER;
		texture = "Interface\\Buttons\\UI-MicroButton-Spellbook-Up";
		keywords = { "class" };
	};
	{
		label = KHAOS_SELECT_DEFAULT;
		header = KHAOS_SELECT_DEFAULT_HEADER;
		texture = "Interface\\Buttons\\UI-MicroButton-MainMenu-Up";
		keywords = { "default" };
	};
};

--------------------------------------------------
--
-- General Function
--
--------------------------------------------------

function ToggleKhaosFrame()
	if ( KhaosFrame:IsVisible() ) then
		HideUIPanel(KhaosFrame);
	else
		ShowUIPanel(KhaosFrame);
	end
end


--[[ Repopulate the Config List ]]--
function KhaosConfig_ChangeConfigList(id)
	local tree = KhaosConfig_GetConfigurationTree(id);
	EarthTree_LoadEnhanced(KhaosFrameConfigurationSelectPaneContainerTree, tree);
end

--[[ Builds the Config List for a Particular Type ]]--
function KhaosConfig_GetConfigurationTree(id)
	local configs = {};
	local keywords = Khaos_Select_Groups[id].keywords;

	for i=1,table.getn(Khaos_Configurations) do
		for k,v in keywords do
			-- If its got the keyword, include it
			if ( v == "all" or Khaos_Configurations[i].keywords[v] ~= nil ) then 
				table.insert(configs, i);
				break;
			end
		end
	end

	local tree = {[1]={}};
	tree[1].children = {};
	tree[1].title = string.format(KHAOS_SELECT_HEADER, Khaos_Select_Groups[id].header);
	tree[1].titleColor = NORMAL_FONT_COLOR;
	tree[1].onClick = KhaosConfig_ConfigHeader_OnClick;
	tree[1].disabled = true;

	local groupedConfigs = {};
	
	if ( id == 1 or id == 5 ) then 
		groupedConfigs = { [1] = configs }; 
	else
		-- Eeek! A super-nested loop! Thankfully, this is very limited in scope...
		for k,cid in configs do
			for _ignore,keyword in Khaos_Select_Groups[id].keywords do

				-- Sort the IDs by their configuration
				for k2,v2 in Khaos_Configurations[cid].keywords[keyword] do
					local keyString = v2;
					if ( not groupedConfigs[keyString] ) then
						groupedConfigs[keyString] = {};
					end

					-- Mark it
					groupedConfigs[keyString][cid] = true;
				end
			end
		end
	end

	-- Sort by key
	local keyStringTable = Sea.table.getKeyList(groupedConfigs);
	table.sort(keyStringTable);
	
	for k,groupValue in keyStringTable do
		local v = groupedConfigs[groupValue];
		local group = {};
		group.children = {};
		group.title = groupValue;
		group.titleColor = NORMAL_FONT_COLOR;
		group.disabled = true;
		table.insert(tree[1].children, group);
		
		for configId,v2 in v do 
			local cid = configId;
			local child = {};
			child.title = Khaos_Configurations[cid].name;
			child.tooltip = KhaosConfig_Configuration_Tooltip;
			child.value = cid;
			child.onClick = KhaosConfig_Config_OnClick;

			if ( cid == KhaosCore.getActiveConfigurationID() ) then 
				KhaosFrameConfigurationSelectPaneContainerTree.selected = child;
			end
			table.insert(group.children, child);
		end

		table.sort(group.children, function(a,b) return a.title < b.title; end );
	end

	-- Show the -none- message if there's no configurations that match
	if ( table.getn( keyStringTable ) == 0 ) then 
		tree[2] = {
			title=KHAOS_SELECT_NONE_LOCKED;
			titleColor=GRAY_FONT_COLOR;
		};
	end

	-- Stupid special cases!
	if ( id == 1 or id == 5 ) then 
		tree[1].children = tree[1].children[1].children;
	end

	return tree;
end

--[[ Gets the Configuration Set List ]]--
function KhaosConfig_GetSetList (difficulty)
	local tree = {};
	local folders = {};
	
	for id,v in KhaosData.configurationFolders do
		--if ( v.difficulty <= difficulty ) then
			table.insert(folders, id);
		--end
	end

	local sorter = function (a,b)
		if ( a and b and type(KhaosData.configurationFolders[a]) == "table" and type(KhaosData.configurationFolders[b]) == "table" ) then 
			return KhaosData.configurationFolders[a].text < KhaosData.configurationFolders[b].text;
		else
			return false;
		end
	end;

	table.sort(folders, sorter);
	
	for k,id in folders do 
		if ( KhaosData.configurationFolderSets[id] ) then 
			local folder = {};
			folder.title = KhaosData.configurationFolders[id].text;
			folder.titleColor = NORMAL_FONT_COLOR;
			folder.children = {};
			folder.disabled = true;

			for sid, ignore in  KhaosData.configurationFolderSets[id] do
				local set = KhaosData.configurationSets[sid];
				if ( set.difficulty <= difficulty ) then 
					local tset = {};
					tset.title = set.text;
					tset.tooltip = function() KhaosConfig_SetDescription(set.helptext, "SET"); end;
					tset.value = sid;
					tset.check = true;
					tset.checked = Khaos.getSetEnabled(sid);
					tset.noTextIndent = true;
					tset.onCheck = KhaosConfig_SetCheck_OnClick;
					tset.onClick = KhaosConfig_Set_OnClick;
					table.insert(folder.children, tset);
				end
			end
			if ( table.getn(folder.children) > 0 or (KhaosData.configurationFolders[id].difficulty <= difficulty) ) then 
				folder.right = string.format("(%d)", table.getn(folder.children) );
				folder.rightColor = GRAY_FONT_COLOR;

				table.sort(folder.children, function(a,b) return a.title < b.title end);
				table.insert(tree, folder);
			end
		end
	end

	-- Add all addons 
	
	if ( GetNumAddOns() > 0 ) then
		local folder = {};
		folder.title = KHAOS_FOLDER_ADDONS;
		folder.tooltip = KHAOS_ENABLER_TOOLTIP;
		folder.titleColor = GREEN_FONT_COLOR;
		folder.collapsed = true;
		folder.children = {};
		folder.disabled = true;

		for i=1, GetNumAddOns() do 
			local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i);
			local deps = { GetAddOnDependencies(name) };

			loaded = IsAddOnLoaded(name);
			--loaded, reason = LoadAddOn(index or "name")

			local tooltip = notes;
			
			if ( not tooltip ) then 
				tooltip = "";
			end
			
			tooltip = tooltip.."\n"..KHAOS_ENABLER_DEPENDENCIES;
			for k,v in deps do 
				tooltip = tooltip.." "..v.."\n";
			end
			
			local addOn = {};
			addOn.title = title;
			addOn.tooltip = tooltip; 
			addOn.value = name;
			addOn.check = true;
			addOn.checked = enabled;
			addOn.noTextIndent = true;
			addOn.onCheck = KhaosConfig_Enabler_OnCheck;
			addOn.onClick = KhaosConfig_Enabler_OnClick;
			table.insert(folder.children,addOn);

		end
		table.insert(tree, 1, folder);		
	end
	
	
	-- Add all unloaded addons 
	
	if ( GetNumAddOns() > 0 ) then 
		local folder = {};
		folder.title = KHAOS_LOADER_TITLE;
		folder.titleColor = GREEN_FONT_COLOR;
		folder.children = {};
		folder.disabled = true;

		for i=1, GetNumAddOns() do 
			local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i);
			dep1, dep2, dep3, dep4, dep5, dep6 = GetAddOnDependencies(name);
			loaded = IsAddOnLoaded(name);
			--loaded, reason = LoadAddOn(index or "name")

			if ( loadable and not loaded ) then 
				local addOn = {};
				addOn.title = title;
				addOn.tooltip = notes; 
				addOn.value = name;
				addOn.check = true;
				addOn.checked = false;
				addOn.noTextIndent = true;
				addOn.onCheck = KhaosConfig_Loader_OnCheck;
				addOn.onClick = KhaosConfig_Loader_OnClick;
				table.insert(folder.children,addOn);
			end
		end

		if ( table.getn(folder.children) > 0 ) then
			table.insert(tree, folder);
		end
	end
	return tree;
end


--[[ Updates the Active Text banner ]]--
function KhaosConfig_UpdateActiveBanner()
	local id = KhaosCore.getActiveConfigurationID();
	local cfg = KhaosCore.getConfiguration(id);

	KhaosFrameCurrentConfigurationText:SetText(string.format(KHAOS_CURRENT_CONFIGURATION_TEXT, id, cfg.name ) );
end

--[[ Updates the Configuration List ]]--
function KhaosConfig_UpdateConfigurationPane ()
	KhaosConfig_ChangeConfigList(KhaosFrame.selectedTab);
	EarthTree_UpdateFrame(KhaosFrameConfigurationSelectPaneContainerTree);
end

--[[ Updates the Configuration Change Panel ]]--
function KhaosConfig_UpdateSetPane()
	EarthTree_LoadEnhanced(KhaosFrameSetSelectPaneContainerTree, KhaosConfig_GetSetList(KhaosCore.getDifficulty()));
	EarthTree_UpdateFrame(KhaosFrameSetSelectPaneContainerTree);
end

--[[ Updates the Configuration Change Panel ]]--
function KhaosConfig_UpdateOptionPane()
	local currentSet = KhaosCore.getCurrentSet();

	if ( not currentSet ) then
		for id=1,KHAOS_CONFIG_COUNT do 
			KhaosConfig_Option_ClearOption(id);
		end

		--KhaosConfig_OptionPane_UpdateFauxScrollFrameRange(0);
		--KhaosFrameResetButton:Disable();
		KhaosFrameTableOfContentsButton:Disable();
		
		return;
	end
	
	-- Update the faux range
	KhaosConfig_OptionPane_UpdateFauxScrollFrameRange(KhaosConfig_GetOptionCountBySetId(currentSet), KhaosCore.getOffset());
	
	for id=1,KHAOS_CONFIG_COUNT do 
		local option = KhaosConfig_GetOptionBySetIdAndFrameId(currentSet, id);
		
		if ( option ) then 
			KhaosConfig_Option_LoadOption(id, option);
		else
			KhaosConfig_Option_ClearOption(id);
		end
	end

	--KhaosFrameResetButton:Enable();
	KhaosFrameTableOfContentsButton:Enable();
end

--[[ Loads a Khaos Option into the specified bar ]]--
function KhaosConfig_Option_LoadOption(id, option)
	-- Flag the configuration as drawing
	KhaosData.configurationDrawing = KhaosData.configurationDrawing + 1;

	-- Clear it first
	KhaosConfig_Option_ClearOption(id);

	-- Load it into the gui
	local base = "KhaosFrameOptionSetupPaneContainerConfig";

	local text = getglobal(base..id.."Text");
	local header = getglobal(base..id.."Header");
	local check = getglobal(base..id.."Check");
	local radio = getglobal(base..id.."Radio");
	local button = getglobal(base..id.."Button");
	local slider = getglobal(base..id.."Slider");
	local pulldown = getglobal(base..id.."Pulldown");
	local colorswatch = getglobal(base..id.."ColorSwatch");
	local textinput = getglobal(base..id.."TextInput");

	-- Determine if it is already disabled
	local isDisabled = false;
	local currentSet = KhaosCore.getCurrentSet();
	
	if ( not Khaos.getSetEnabled( currentSet ) ) then 
		isDisabled = true;
	end
	-- Consider outside elements only
	if ( KhaosConfig_IsOptionDisabled( option, currentSet, false) ) then 
		isDisabled = true;
	end

	-- Grab the data needed
	local key = {};
	if ( option.key ) then 
		if ( isDisabled ) then 
			key = option.disabled;
		else
			key = Khaos.getSetKey(currentSet, option.key);
		end
	end

	-- Update Check
	if ( option.check ) then 
		check:Show();
		if ( key.checked ) then 
			--check:SetChecked(key.checked);
			check:SetChecked(1);
		end

		if ( isDisabled ) then
			check:Disable();
		else
			check:Enable();
		end
	end
		
	-- Update Radio
	if ( option.radio ) then 
		check:Hide();
		radio:Show();
		if ( key.value == option.value ) then 
			--radio:SetChecked(true);
			radio:SetChecked(1);
		end

		if ( option.setup and option.setup.selectedColor ) then 
			getglobal(radio:GetName().."CheckedTexture"):SetVertexColor(option.setup.selectedColor.r, option.setup.selectedColor.g, option.setup.selectedColor.b);
		else
			getglobal(radio:GetName().."CheckedTexture"):SetVertexColor(1,1,1);
		end

		if ( option.setup and option.setup.disabledColor ) then 
			getglobal(radio:GetName().."DisabledCheckedTexture"):SetVertexColor(option.setup.disabledColor.r,option.setup.disabledColor.g,option.setup.disabledColor.b);
		else
			getglobal(radio:GetName().."DisabledCheckedTexture"):SetVertexColor(1,1,1);
		end
		
		if ( isDisabled ) then
			radio:Disable();
		else
			radio:Enable();
		end
	end

	-- Consider self
	if ( KhaosConfig_IsOptionDisabled( option, currentSet, true) ) then 
		isDisabled = true;
	end

	if ( isDisabled ) then 
		key = option.disabled;
	end
	
	-- Type Checking
	if ( option.type == K_TEXT ) then 
		local optionText = option.text; 
		if ( type ( optionText ) == "function" ) then optionText = optionText(key) end;
		
		text:Show();
		getglobal(text:GetName().."Label"):SetText(optionText);
	elseif ( option.type == K_BUTTON ) then 
		local optionText = option.text; 
		if ( type ( optionText ) == "function" ) then optionText = optionText(key) end;
		
		text:Show();
		getglobal(text:GetName().."Label"):SetText(optionText);

		button:Show();
		if ( option.setup.buttonText ) then 
			button:SetText(option.setup.buttonText);
		else
			button:SetText("");
		end
		
		if ( isDisabled ) then
			button:Disable();
		else
			button:Enable();
		end

	elseif ( option.type == K_SLIDER ) then 
		local optionText = option.text; 
		if ( type ( optionText ) == "function" ) then optionText = optionText(key) end;
		
		text:Show();
		getglobal(text:GetName().."Label"):SetText(optionText);
		slider:SetMinMaxValues(option.setup.sliderMin, option.setup.sliderMax);
		slider:SetValueStep(option.setup.sliderStep);

		-- Set slider text if available
		if ( option.setup.sliderText ) then 
			getglobal(slider:GetName().."Text"):SetText(option.setup.sliderText);
		else
			getglobal(slider:GetName().."Text"):SetText("");
		end

		-- Format state if possible
		if ( option.setup.sliderDisplayFunc ) then 
			slider.valueFunc = option.setup.sliderDisplayFunc;
			getglobal(slider:GetName().."ValueText"):SetText(option.setup.sliderDisplayFunc(key.slider));
		else
			slider.valueFunc = nil;
			if ( key.slider ) then 
				getglobal(slider:GetName().."ValueText"):SetText(key.slider);
			else
				getglobal(slider:GetName().."ValueText"):SetText("-");
			end
		end

		-- Add low/high texts to slider
		if ( option.setup.sliderLowText ) then 
			getglobal(slider:GetName().."Low"):SetText(option.setup.sliderLowText);
		else
			getglobal(slider:GetName().."Low"):SetText(LOW);
		end	
		if ( option.setup.sliderHighText ) then 
			getglobal(slider:GetName().."High"):SetText(option.setup.sliderHighText);
		else
			getglobal(slider:GetName().."High"):SetText(HIGH);
		end
		
		if ( isDisabled ) then
			slider:Disable();
			getglobal(text:GetName().."Label"):SetVertexColor(.5, .5, .5);
		else
			slider:Enable();
			getglobal(text:GetName().."Label"):SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		end

		if ( key.slider ) then 
			slider:SetValue(key.slider);
		else
			slider:SetValue(option.default.slider);
		end
		slider:Show();		

	elseif ( option.type == K_PULLDOWN ) then 
		local optionText = option.text; 
		if ( type ( optionText ) == "function" ) then optionText = optionText(key) end;
		
		text:Show();
		getglobal(text:GetName().."Label"):SetText(optionText);

		pulldown:Show();		
		
		if ( option.setup.multiSelect == false and key.value ) then 
			--Get the key to use as text, instead of the value, if available
			local valueText = key.value;
			if ( option.setup and ( type(option.setup.options) == "table" ) ) then
				for curKey in option.setup.options do
					if ( option.setup.options[curKey] == key.value ) then
						valueText = curKey;
						break;
					end
				end
			end
			getglobal(pulldown:GetName().."Text"):SetText(valueText);
		else
			getglobal(pulldown:GetName().."Text"):SetText(KHAOS_OPTION_CHOOSE);
		end
		
		if ( isDisabled ) then
			pulldown:Disable();
			getglobal(pulldown:GetName().."Text"):SetVertexColor(.5, .5, .5);
		else
			pulldown:Enable();
			getglobal(pulldown:GetName().."Text"):SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		end
	elseif ( option.type == K_EDITBOX ) then 
		local optionText = option.text; 
		if ( type ( optionText ) == "function" ) then optionText = optionText(key) end;
		
		text:Show();
		getglobal(text:GetName().."Label"):SetText(optionText);

		textinput:Show();
		textinput:SetText(key.value);
		
		if ( isDisabled ) then
			textinput:Disable();
		else
			textinput:Enable();
		end
	elseif ( option.type == K_COLORPICKER ) then 
		local optionText = option.text; 
		if ( type ( optionText ) == "function" ) then optionText = optionText(key) end;
		
		text:Show();
		getglobal(text:GetName().."Label"):SetText(optionText);
		
		colorswatch:Show();
		if ( isDisabled ) then
			getglobal(colorswatch:GetName().."NormalTexture"):SetVertexColor(option.disabled.color.r,option.disabled.color.g,option.disabled.color.b);
			colorswatch:Disable();
			if ( option.disabled.color.opacity ) then 
				colorswatch:SetAlpha(option.disabled.color.opacity);
			else
				colorswatch:SetAlpha(1.0);
			end				
		else
			colorswatch:Enable();
			getglobal(colorswatch:GetName().."NormalTexture"):SetVertexColor(key.color.r,key.color.g,key.color.b);
			if ( key.color.opacity ) then 
				getglobal(colorswatch:GetName().."NormalTexture"):SetAlpha(key.color.opacity);
			else
				getglobal(colorswatch:GetName().."NormalTexture"):SetAlpha(1.0);
			end				
		end
	elseif ( option.type == K_HEADER ) then 
		local optionText = option.text; 
		if ( type ( optionText ) == "function" ) then optionText = optionText(key) end;
		
		header:Show();
		getglobal(header:GetName().."Label"):SetText(optionText);
		if ( isDisabled ) then
			getglobal(header:GetName().."Label"):SetVertexColor(.5,.5,.5);
		else
			getglobal(header:GetName().."Label"):SetVertexColor(NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b);
		end

	end

	-- Disable text color
	if ( isDisabled ) then
		getglobal(text:GetName().."Label"):SetVertexColor(.5,.5,.5);
	else
		getglobal(text:GetName().."Label"):SetVertexColor(NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b);
	end
	

	-- Unflag the configuration as drawing
	KhaosData.configurationDrawing = KhaosData.configurationDrawing - 1;
end

--[[ Wipes a set of options clean ]]--
function KhaosConfig_Option_ClearOption(id)
	if ( id == nil ) then Sea.io.error("nil config id!"); return; end

	-- Flag the configuration as drawing
	KhaosData.configurationDrawing = KhaosData.configurationDrawing + 1;

	local base = "KhaosFrameOptionSetupPaneContainerConfig";

	local text = getglobal(base..id.."Text");
	local header = getglobal(base..id.."Header");
	local check = getglobal(base..id.."Check");
	local radio = getglobal(base..id.."Radio");
	local button = getglobal(base..id.."Button");
	local slider = getglobal(base..id.."Slider");
	local pulldown = getglobal(base..id.."Pulldown");
	local colorswatch = getglobal(base..id.."ColorSwatch");
	local textinput = getglobal(base..id.."TextInput");

	-- Reset text
	text:Hide();
	getglobal(text:GetName().."Label"):SetText("");

	-- Reset header
	header:Hide();
	getglobal(header:GetName().."Label"):SetText("");

	-- Reset check
	check:Hide();
	check:SetChecked(nil);

	-- Reset the radio
	radio:Hide();
	radio:SetChecked(nil);
	
	-- Reset the color
	getglobal(radio:GetName().."CheckedTexture"):SetVertexColor(1,1,1);
	getglobal(radio:GetName().."DisabledCheckedTexture"):SetVertexColor(.5,.5,.5);

	-- Reset the button
	button:Hide();
	button:SetText("");

	-- Reset the slider
	slider:Hide();
	getglobal(slider:GetName().."Text"):SetText("");
	getglobal(slider:GetName().."ValueText"):SetText("");
	getglobal(slider:GetName().."Low"):SetText(LOW);
	getglobal(slider:GetName().."High"):SetText(HIGH);

	-- Reset the pulldown button
	pulldown:Hide();
	getglobal(pulldown:GetName().."Text"):SetText("");

	-- Reset the color swatch
	colorswatch:Hide();
	getglobal(colorswatch:GetName().."SwatchBg"):SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);

	-- Reset the text input
	textinput:Hide();
	textinput:SetText("");

	-- Unflag the configuration as drawing
	KhaosData.configurationDrawing = KhaosData.configurationDrawing - 1;
end;

--[[ Update the Faux Scroll Frame ]]--
function KhaosConfig_OptionPane_UpdateFauxScrollFrameRange(range, offset)
	if ( not offset ) then 
		offset = 0; 
	else	
		KhaosFrameOptionSetupPaneContainerScrollFrameScrollBar:SetValue(offset*KHAOS_CONFIG_HEIGHT);
	end

	FauxScrollFrame_Update(KhaosFrameOptionSetupPaneContainerScrollFrame, range, 10, KHAOS_CONFIG_HEIGHT );
end;

--[[ Event Handler ]]--
function KhaosConfig_OptionPane_ScrollFrame_OnVerticalScroll()
	if ( not KhaosData.changingOffset ) then 
		KhaosData.changingOffset=true;
		local scrollbar = getglobal(this:GetName().."ScrollBar");
		scrollbar:SetValue(arg1);
		this.offset = floor((arg1 / KHAOS_CONFIG_HEIGHT) + 0.5)
		KhaosCore.setOffset(FauxScrollFrame_GetOffset(this));
		Khaos.refresh(false,false,true);
		KhaosData.changingOffset=false;
	end
end

--[[ Gets an option by the specified set and id ]]--
function KhaosConfig_GetOptionBySetIdAndFrameId(setID, frameID)
	local set = KhaosData.configurationSets[setID];
	local offset = KhaosCore.getOffset();
	local configID = offset + frameID;

	local difficulty = KhaosCore.getDifficulty();

	local optionTable = {};

	for i=1,table.getn(KhaosData.configurationSets[setID].options) do 
		if ( KhaosData.configurationSets[setID].options[i].difficulty <= difficulty ) then 
			configID = configID - 1;

			if ( configID == 0 ) then
				return KhaosData.configurationSets[setID].options[i];
			end;
		end
	end
	
	return nil;
end

--[[ Gets an option by the specified set and id ]]--
function KhaosConfig_GetOptionCountBySetId(setID)
	if ( not KhaosData.configurationSets[setID] ) then
		return 0;
	end;
	local set = KhaosData.configurationSets[setID];
	local difficulty = KhaosCore.getDifficulty();

	local count = 0;
	
	for i=1,table.getn(set.options) do 
		if ( set.options[i].difficulty <= difficulty ) then 
			count = count + 1;
		end
	end
	
	return count;
end

--[[ Gets the visibile option set by set id ]]--
function KhaosConfig_GetVisibleOptionsBySetId(setID)
	local visibleSet = {};
	if ( setID ) then 
		local set = KhaosData.configurationSets[setID];
		local difficulty = KhaosCore.getDifficulty();
	
		for i=1,table.getn(set.options) do 
			if ( set.options[i].difficulty <= difficulty ) then 
				table.insert( visibleSet, set.options[i] );
			end
		end
	end
	return visibleSet;
end

--[[ Checks an option's dependencies ]]--
function KhaosConfig_IsOptionDisabled(option, currentSet, considerSelf, cfg)
	Sea.io.dprint(K_DEBUG_V, "Checking ", option.id, " from set ", currentSet, " considering self: ", considerSelf, " using cfg? ", cfg);
	local isDisabled = false;
	if ( not option.dependencies ) then
		return isDisabled;
	end
	
	for k,v in option.dependencies do 
		if ( (k == option.key and considerSelf) or k ~= option.key ) then
			local match = v.match;
			local actual = nil;
			if ( not cfg ) then 
				actual = Khaos.getSetKey(currentSet, k);
			else
				actual = KhaosCore.getSetKeyFromConfig(cfg, currentSet, k);

			end

			if ( actual == nil ) then 
				actual = option.default;
			end

			-- Default to true
			if ( match == nil ) then match = true; end

			-- Match determines whether we test for equality or for inequality
			if ( v.value ~= nil) then
				if ( (actual.value ~= v.value) == match ) then 
					isDisabled = true;
				end
			end
			if ( v.checked ~= nil ) then
				if ( actual and (actual.checked ~= v.checked) == match ) then 
					isDisabled = true;
				end
			end
		end
	end

	return isDisabled;
end

--[[ Handles basic button actions ]]--
function KhaosConfig_Action(action, id, value)
	if ( KhaosData.configurationDrawing ~= 0 ) then 
		return;
	end

	local actionInfo = Sea.string.split(action,"_");
	local actionObject = actionInfo[1];
	local actionEvent = actionInfo[2];
	local actionType = actionInfo[3];

	local currentSet = KhaosCore.getCurrentSet();
	local option = KhaosConfig_GetOptionBySetIdAndFrameId(currentSet, id);
	local update = false;
	
	if ( actionEvent == "ENTER" ) then 
		if ( actionObject == "COLORPICKER" ) then 
			getglobal(this:GetName().."SwatchBg"):SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		end

		-- Show Help
		if ( option and option.helptext ) then 
			if ( option.id ~= KhaosData.surpressId ) then 
				KhaosConfig_SetDescription(option.helptext, actionObject);
			end
		end		
	elseif ( actionEvent == "LEAVE" ) then 
		if ( actionObject == "COLORPICKER" ) then 
			getglobal(this:GetName().."SwatchBg"):SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		end
	else
		local key = {};
		
		-- Load the key
		if ( option.key ) then 
			key = Khaos.getSetKey(currentSet, option.key);
		end
		
		-- Check
		if ( actionObject == "CHECK" ) then 
			if ( actionEvent == "CLICK" ) then 
				if ( value == 1 ) then 
					Sea.io.dprint(K_DEBUG, "Setting the ", currentSet, " key " ,option.key, " checked to true. ");
					Khaos.setSetKeyParameter(currentSet, option.key, "checked", true);
				else
					Sea.io.dprint(K_DEBUG, "Setting the ", currentSet, " key " ,option.key, " checked to false. ");
					Khaos.setSetKeyParameter(currentSet, option.key, "checked", false);
				end
				if ( option.callback ) then 
					option.callback(key);
					if ( option.feedback ) then 
						KhaosData.surpressId = option.id;
						KhaosConfig_SetDescription(option.feedback(key));
					end

					-- Run the callbacks
					KhaosCore.runCallbacks(nil, {currentSet});
					Khaos.refresh(nil, nil, true);
				end
				update = true;
			end
		end

		-- Radio
		if ( actionObject == "RADIO" ) then 
			if ( actionEvent == "CLICK" ) then 
				if ( value == 1 ) then
					Khaos.setSetKeyParameter(currentSet, option.key, "value", option.value);
				else
					-- Will let you uncheck a radio button if check == true
					if ( option.value == key.value and option.check == true ) then 
						Khaos.setSetKeyParameter(currentSet, option.key, "value", nil);
					end
				end				
				if ( option.callback ) then 
					option.callback(key);
					if ( option.feedback ) then 
						KhaosData.surpressId = option.id;
						KhaosConfig_SetDescription(option.feedback(key));
					end

					-- Run the callbacks
					KhaosCore.runCallbacks(nil, {currentSet});
					Khaos.refresh(nil, nil, true);
				end
				update = true;
			end
		end
		
		-- Buttons
		if ( actionObject == "BUTTON" ) then 
			if ( actionEvent == "CLICK" ) then 
				if ( option.callback ) then 
					option.callback(key);
					if ( option.feedback ) then 
						KhaosData.surpressId = option.id;
						KhaosConfig_SetDescription(option.feedback(key));
					end

					-- Run the callbacks
					KhaosCore.runCallbacks(nil, {currentSet});
					Khaos.refresh(nil, nil, true);
				end
			end
		end

		-- Sliders
		if ( actionObject == "SLIDER" ) then 
			if ( actionEvent == "CHANGED") then
				if ( type(option.setup.sliderSignificantDigits) == "number" ) then
					value = math.floor(value*math.pow(10,option.setup.sliderSignificantDigits))/math.pow(10,option.setup.sliderSignificantDigits);
				end
				Khaos.setSetKeyParameter(currentSet, option.key, "slider", value);
				if ( option.callback ) then 
					option.callback(key);
					if ( option.feedback ) then 
						KhaosData.surpressId = option.id;
						KhaosConfig_SetDescription(option.feedback(key));
					end

					-- Run the callbacks
					KhaosCore.runCallbacks(nil, {currentSet});
				end
				Chronos.scheduleByName("KhaosUpdate",1.2,Khaos.refresh, false, false, true);
			end
		end
		
		-- Editboxes
		if ( actionObject == "TEXT" ) then 
			if ( actionEvent == "PRESSED" ) then 
				Khaos.setSetKeyParameter(currentSet, option.key, "value", value);
				
				if ( Sea.list.isInList(option.setup.callOn, string.lower(actionType) ) ) then
					if ( option.callback ) then 
						local result = option.callback(key, string.lower(actionType) );
						if ( result ) then 
							Khaos.setSetKeyParameter(currentSet, option.key, "value", result);
							update = true;
						end
						if ( option.feedback ) then 
							KhaosData.surpressId = option.id;
							KhaosConfig_SetDescription(option.feedback(key));
						end

					end
				end
			end
		end

		-- Pulldowns
		if ( actionObject == "PULLDOWN" ) then 
			if ( actionEvent == "CLICK" ) then 
				-- Create a menu and fill it up
				local lset = currentSet;
				local loption = option;
				local menu = {};
				local options = option.setup.options;
				if ( type ( options ) == "function" ) then options = options(key); end;

				for k,v in options do
					local item = {};
					
					item.func = function(checked, value) 
						KhaosConfig_Pulldown_UpdateValue(checked, value, lset, loption); 
					end;
					if ( type(k) == "string" ) then 
						item.text = k;
					else
						item.text = v;
					end
					item.value = v;

					if ( option.setup.multiSelect == true ) then 
						if ( Sea.list.isInList(key.options, v) ) then
							item.checked = true;
						end
					elseif ( key.value == v ) then 
						item.checked = true;
					end
					
					if ( option.setup.multiSelect ) then 
						item.keepShownOnClick = 1;
					end

					table.insert(menu, item);
				end

				EarthMenu_MenuOpen(menu, this:GetName(), -50, 0, "MENU", 3);
			end	
		end

		-- Color Swatch
		if ( actionObject == "COLORPICKER" ) then 
			if ( actionEvent == "CLICK" ) then
				local lset = currentSet;
				local loption = option;
				local colorTask = {};
				local updateFunc = function()  
					KhaosConfig_ColorPicker_UpdateValue ( lset, loption );

					-- Show the Khaos Frame after picking
					if ( not ColorPickerFrame:IsVisible() ) then 
						ShowUIPanel(KhaosFrame);
					end
				end;
				local cancelFunc = function(oldColors) 
					Khaos.setSetKeyParameter(lset, loption.key, "color", oldColors); 
					-- Load the key
					if ( loption.key ) then 
						key = Khaos.getSetKey(lset, loption.key);
					end
					loption.callback(key);
					if ( loption.feedback ) then 
						KhaosData.surpressId = loption.id;
						KhaosConfig_SetDescription(loption.feedback(key));
					end
					-- Run the callbacks
					KhaosCore.runCallbacks(nil, {currentSet});
					Khaos.refresh(nil, nil, true);

					-- Show the KhaosFrame after canceling
					ShowUIPanel(KhaosFrame);
				end;

				colorTask.r = key.color.r;
				colorTask.g = key.color.g;
				colorTask.b = key.color.b;
				colorTask.previousValues = key.color;
				if ( option.setup.hasOpacity ) then 
					colorTask.hasOpacity = true;
					colorTask.opacityFunc = updateFunc;
					colorTask.opacity = key.color.opacity;
					colorTask.previousValues.opacity = key.color.opacity;
				else
					colorTask.previousValues.opacity = 1.0;
					colorTask.opacity = 1.0;
				end
				colorTask.func = updateFunc;
				colorTask.cancelFunc = cancelFunc;

				KhaosConfig_ColorPicker_Display(colorTask);
			end						
		end
	end

	-- Redraw the GUI
	if ( update ) then 
		Khaos.refresh(false, false, true);
	end
end

--[[ Updates a K_PULLDOWN Multi-Select ]]--
function KhaosConfig_Pulldown_UpdateValue(checked, value, set, option)
	Sea.io.dprint(K_DEBUG, "Pulldown select: ", value, " was ", checked, " for ", set );
	local key = {};

	-- Load the key
	if ( option.key ) then 
		key = Khaos.getSetKey(set, option.key);
	end

	if ( option.setup.multiSelect ) then 
		if ( checked ) then 
			if ( not Sea.list.isInList(key.options, value) ) then 
				table.insert(key.options, value);
			end
		else			
			for k,v in key.options do 
				if ( v == value ) then
					table.remove(key.options, k);
				end
			end
		end

		Khaos.setSetKeyParameter(set, option.key, "options", key.options);
		option.callback(key);
		if ( option.feedback ) then 
			KhaosData.surpressId = option.id;
			KhaosConfig_SetDescription(option.feedback(key));
		end
		-- Run the callbacks
		KhaosCore.runCallbacks(nil, {currentSet});
		Khaos.refresh(nil, nil, true);
	else
		Khaos.setSetKeyParameter(set, option.key, "value", value);
		option.callback(key);
		if ( option.feedback ) then 
			KhaosData.surpressId = option.id;
			KhaosConfig_SetDescription(option.feedback(key));
		end
		-- Run the callbacks
		KhaosCore.runCallbacks(nil, {currentSet});
		Khaos.refresh(nil, nil, true);
	end

	Khaos.refresh(false, false, true);
end

--[[ Loads a Configuration into the GUI ]]--
function KhaosConfig_LoadConfigurationIntoGui(id)
	KhaosCore.saveConfiguration();
	KhaosCore.loadConfiguration(id);
	KhaosConfig_UpdateActiveBanner();
	KhaosConfig_UpdateConfigurationPane();
	KhaosConfig_UpdateSetPane();
	KhaosConfig_UpdateOptionPane();
	Khaos.refresh();
end

--[[ Creates the difficulty Menu ]]--
function KhaosConfig_CreateTocMenu()
	local menu = {
		{ text = KHAOS_OPTION_TABLEOFCONTENTS_MENU_TITLE; isTitle = true; };
	};

	local visibleOptions = KhaosConfig_GetVisibleOptionsBySetId(KhaosCore.getCurrentSet());
	local count = 0;
	-- Create KHAOS_DIFFICULTY_COUNT difficulties
	for i=1,table.getn(visibleOptions) do 
		if ( visibleOptions[i].type == K_HEADER ) then
			count = count + 1;
			local menuItem = {};
			menuItem.text = string.format(KHAOS_OPTION_TABLEOFCONTENTS_MENU_FORMAT, count, visibleOptions[i].text);
			menuItem.value = i-1;
			menuItem.func = KhaosConfig_ChangeOffset;

			if ( KhaosCore.getOffset() == i-1 ) then
				menuItem.checked = true;
			end

			table.insert(menu, menuItem);
		elseif ( i == 1 ) then 
			local menuItem = {};
			menuItem.text = string.format(KHAOS_OPTION_TABLEOFCONTENTS_MENU_TOP);
			menuItem.value = i-1;
			menuItem.func = KhaosConfig_ChangeOffset;

			table.insert(menu, menuItem);
		elseif ( i == table.getn(visibleOptions) ) then
			local menuItem = {};
			menuItem.text = string.format(KHAOS_OPTION_TABLEOFCONTENTS_MENU_BOTTOM);
			menuItem.value = i;
			menuItem.func = KhaosConfig_ChangeOffset;

			table.insert(menu, menuItem);
		end

	end

	return menu;
end

--[[ Creates the difficulty Menu ]]--
function KhaosConfig_CreateDifficultyMenu()
	local menu = {
		{ text = KHAOS_SET_DIFFICULTY_MENU_TITLE; isTitle = true; };
	};

	-- Create KHAOS_DIFFICULTY_COUNT difficulties
	for i=1,KHAOS_DIFFICULTY_COUNT do 
		local menuItem = {};
		menuItem.text = string.format(KHAOS_SET_DIFFICULTY_MENU_FORMAT, i, getglobal("KHAOS_SET_DIFFICULTY_"..i));
		menuItem.value = i;
		menuItem.func = KhaosConfig_ChangeDifficulty;

		if ( KhaosData.defaultLevel == i ) then
			menuItem.text = menuItem.text.." "..KHAOS_SET_DIFFICULTY_DEFAULT;
		end
		if ( KhaosCore.getDifficulty() == i ) then
			menuItem.checked = true;
		end

		table.insert(menu, menuItem);
	end

	return menu;
end

--[[ Handles Callbacks from Difficulty Menu ]]--
function KhaosConfig_ChangeDifficulty(checked, value)
	KhaosCore.setOffset(0);
	KhaosCore.setDifficulty(value);

	-- Sort of hackish - maybe it should be inside of refresh?
	Khaos_Frame_DifficultyUpdate();	
	Khaos.refresh(false,true,true);
end

function KhaosConfig_ChangeOffset(checked, offset)
	KhaosCore.setOffset(offset);
	Khaos.refresh(false,false,true);
end

--[[ Displays Text in the Description Box ]]--
function KhaosConfig_SetDescription(text, source)
	if ( type(text) == "function" ) then 
		text = text(source);
	end
	KhaosConfig_ClearDescription();
	if ( type(text) == "string" ) then 
		KhaosFrameDescriptionBox:AddMessage("\n"..text.."\n", KHAOS_DESCRIPTION_COLOR.r, KHAOS_DESCRIPTION_COLOR.g, KHAOS_DESCRIPTION_COLOR.b);
	end
end

--[[ Clears the Description Box Text ]]--
function KhaosConfig_ClearDescription()
	KhaosFrameDescriptionBox:AddMessage("\n\n\n\n");
end

--------------------------------------------------
-- Tooltip Generators
--------------------------------------------------
function KhaosConfig_Configuration_Tooltip(value)
	local cid = value;
	local tooltip = nil;
	if ( Khaos_Configurations[cid] ) then 
		tooltip = "|c"..KHAOS_TOOLTIP_COLOR_STRING;

		tooltip = tooltip..Khaos_Configurations[cid].name.."|r\n";

		if ( Khaos_Configurations[cid].keywords ) then 
			if ( Khaos_Configurations[cid].keywords.default ) then 
				tooltip = tooltip.."|c"..KHAOS_TOOLTIP_SUB_COLOR_STRING..KHAOS_CONFIG_TOOLTIP_DEFAULT.."|r\n";
			end
			if ( Khaos_Configurations[cid].keywords.class ) then 
				tooltip = tooltip.."\n"..KHAOS_CONFIG_TOOLTIP_CLASSES.."\n";

				local count = 0;
				for k,v in Khaos_Configurations[cid].keywords.class do					
					count = count + 1;

					if ( type(k) == "string" ) then 
						tooltip = tooltip.." "..Khaos_Configuration_Data.classes[k];
					else
						tooltip = tooltip.." "..Khaos_Configuration_Data.classes[v];
					end
					if ( count == 2 ) then 
						tooltip = tooltip.."\n";
						count = 0;
					else
						tooltip = tooltip.." ";
					end
				end
			end
			if ( Khaos_Configurations[cid].keywords.realm ) then 
				tooltip = tooltip.."\n"..KHAOS_CONFIG_TOOLTIP_REALMS.."\n";

				local count = 0;
				for k,v in Khaos_Configurations[cid].keywords.realm do					
					count = count + 1;

					if ( type(k) == "string" ) then 
						tooltip = tooltip.." "..k;
					else
						tooltip = tooltip.." "..v;
					end
					if ( count == 2 ) then 
						tooltip = tooltip.."\n";
						count = 0;
					else
						tooltip = tooltip.." ";
					end
				end
			end
			if ( Khaos_Configurations[cid].keywords.character ) then 
				tooltip = tooltip.."\n"..KHAOS_CONFIG_TOOLTIP_CHARACTERS.."\n";

				local count = 0;
				for k,v in Khaos_Configurations[cid].keywords.character do
					count = count + 1;

					if ( type(k) == "string" ) then 
						tooltip = tooltip.." "..k;
					else
						tooltip = tooltip.." "..v;
					end
					if ( count == 2 ) then 
						tooltip = tooltip.."\n";
						count = 0;
					else
						tooltip = tooltip.." ";
					end
				end
			end
		end

		tooltip = tooltip.."\r";
	end

	return tooltip;
end

--------------------------------------------------
--
-- Event Handlers
--
--------------------------------------------------

function KhaosConfig_OnMouseWheel(delta)
	-- Update the GUI Faux Scroll Frame
	-- 
	local max = KhaosConfig_GetOptionCountBySetId( KhaosCore.getCurrentSet() );

	KhaosCore.setOffset( KhaosCore.getOffset() - delta );

	-- Update the scroll frame
	KhaosConfig_OptionPane_UpdateFauxScrollFrameRange(max+1, KhaosCore.getOffset());

	-- Refresh the UI's Option Pane only
	Khaos.refresh(nil,nil,true);
end;

--------------------------------------------------
-- Frame
--------------------------------------------------
function KhaosConfig_ConfigFrame_OnLoad()
	this.onMouseWheel = KhaosConfig_OnMouseWheel;
end;
--------------------------------------------------
-- Text
--------------------------------------------------
function KhaosConfig_Text_OnLoad()
	this.onEnter = KhaosConfig_Text_OnEnter;
	this.onLeave = KhaosConfig_Text_OnLeave;
	this.onMouseWheel = KhaosConfig_OnMouseWheel;
end
function KhaosConfig_Text_OnEnter()
	KhaosConfig_Action( "TEXT_ENTER", this:GetParent():GetID() );
end
function KhaosConfig_Text_OnLeave()
	KhaosConfig_Action( "TEXT_LEAVE", this:GetParent():GetID());
end
--------------------------------------------------
-- Headers
--------------------------------------------------
function KhaosConfig_Header_OnLoad()
	this.onEnter = KhaosConfig_Header_OnEnter;
	this.onLeave = KhaosConfig_Header_OnLeave;
	this.onMouseWheel = KhaosConfig_OnMouseWheel;
end
function KhaosConfig_Header_OnEnter()
	KhaosConfig_Action( "HEADER_ENTER", this:GetParent():GetID() );
end
function KhaosConfig_Header_OnLeave()
	KhaosConfig_Action( "HEADER_LEAVE", this:GetParent():GetID());
end
--------------------------------------------------
-- Radio Buttons
--------------------------------------------------

function KhaosConfig_Radio_OnLoad()
	this.onClick = KhaosConfig_Radio_OnClick;
	this.onEnter = KhaosConfig_Radio_OnEnter;
	this.onLeave = KhaosConfig_Radio_OnLeave;
	this.onMouseWheel = KhaosConfig_OnMouseWheel;
end

function KhaosConfig_Radio_OnClick()
	KhaosConfig_Action( "RADIO_CLICK", this:GetParent():GetID(), this:GetChecked() );
end
function KhaosConfig_Radio_OnEnter()
	KhaosConfig_Action( "RADIO_ENTER", this:GetParent():GetID(), this:GetChecked() );
end
function KhaosConfig_Radio_OnLeave()
	KhaosConfig_Action( "RADIO_LEAVE", this:GetParent():GetID(), this:GetChecked() );
end

--------------------------------------------------
-- Check Buttons
--------------------------------------------------

function KhaosConfig_Check_OnLoad()
	this.onClick = KhaosConfig_Check_OnClick;
	this.onEnter = KhaosConfig_Check_OnEnter;
	this.onLeave = KhaosConfig_Check_OnLeave;
	this.onMouseWheel = KhaosConfig_OnMouseWheel;
end

function KhaosConfig_Check_OnClick()
	KhaosConfig_Action( "CHECK_CLICK", this:GetParent():GetID(), this:GetChecked() );
end
function KhaosConfig_Check_OnEnter()
	KhaosConfig_Action( "CHECK_ENTER", this:GetParent():GetID(), this:GetChecked() );
end
function KhaosConfig_Check_OnLeave()
	KhaosConfig_Action( "CHECK_LEAVE", this:GetParent():GetID(), this:GetChecked() );
end

--------------------------------------------------
-- Button Buttons
--------------------------------------------------

function KhaosConfig_Button_OnLoad()
	this.onClick = KhaosConfig_Button_OnClick;
	this.onMouseWheel = KhaosConfig_OnMouseWheel;
end

function KhaosConfig_Button_OnClick()
	KhaosConfig_Action("BUTTON_CLICK", this:GetParent():GetID());
end

--------------------------------------------------
-- Sliders
--------------------------------------------------
function KhaosConfig_Slider_OnLoad()
	this.onValueChanged = KhaosConfig_Slider_OnValueChanged;
	this.onEnter = KhaosConfig_Slider_OnEnter;
	this.onLeave = KhaosConfig_Slider_OnLeave;
	this.Disable = KhaosConfig_Slider_Disable;
	this.Enable  = KhaosConfig_Slider_Enable;
	this.onMouseWheel = KhaosConfig_OnMouseWheel;
end
function KhaosConfig_Slider_OnValueChanged()
	if ( this.valueFunc ) then
		local tval = this.valueFunc(arg1);
		getglobal(this:GetName().."ValueText"):SetText(tval);
	else
		getglobal(this:GetName().."ValueText"):SetText(arg1);
	end
	KhaosConfig_Action("SLIDER_CHANGED", this:GetParent():GetID(), arg1);
end
function KhaosConfig_Slider_OnEnter()
	KhaosConfig_Action("SLIDER_ENTER", this:GetParent():GetID());	
end
function KhaosConfig_Slider_OnLeave()
	KhaosConfig_Action("SLIDER_LEAVE", this:GetParent():GetID());
end
function KhaosConfig_Slider_Disable(this)
	if ( not this.disabled ) then
		this.disabled = true;
		this.lockValue = this:GetValue();
		this.oldValueChanged = this.onValueChanged;
		this.onValueChanged = function () if ( not this.ignore ) then this.ignore=true; this:SetValue(this.lockValue); this.ignore=false; end end;
		getglobal(this:GetName().."Text"):SetVertexColor(.5,.5,.5);
		getglobal(this:GetName().."ValueText"):SetVertexColor(.5,.5,.5);
		getglobal(this:GetName().."Low"):SetVertexColor(.5,.5,.5);
		getglobal(this:GetName().."High"):SetVertexColor(.5,.5,.5);
	end
end
function KhaosConfig_Slider_Enable(this)
	if ( this.disabled ) then 
		this.disabled = nil;
		this:SetValue(this.lockValue);
		this.onValueChanged = this.oldValueChanged;
		getglobal(this:GetName().."Text"):SetVertexColor(NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b);
		getglobal(this:GetName().."ValueText"):SetVertexColor(.4,.6,1);
		getglobal(this:GetName().."Low"):SetVertexColor(1,1,1);
		getglobal(this:GetName().."High"):SetVertexColor(1,1,1);
	end
end

--------------------------------------------------
-- Color Picker
--------------------------------------------------
function KhaosConfig_ColorPicker_UpdateValue ( set, option )
	local key = {};
	local color = {};
	color.r,color.g,color.b = ColorPickerFrame:GetColorRGB();

	if ( option.setup.hasOpacity ) then 
		color.opacity = 1.0 - OpacitySliderFrame:GetValue();
	else
		color.opacity = 1.0;
	end

	Khaos.setSetKeyParameter(set, option.key, "color", color);

	-- Load the key
	if ( option.key ) then 
		key = Khaos.getSetKey(set, option.key);
	end
	
	option.callback(key);
	
	KhaosConfig_UpdateOptionPane();	
end
function KhaosConfig_ColorPicker_Display(colorTask)
	ColorPickerFrame.func = colorTask.func;
	ColorPickerFrame.hasOpacity = colorTask.hasOpacity;
	ColorPickerFrame.opacityFunc = colorTask.opacityFunc;
	if ( colorTask.hasOpacity and colorTask.opacity ) then 
		ColorPickerFrame.opacity = 1 - colorTask.opacity;
	else
		ColorPickerFrame.opacity = 1.0;
	end
	ColorPickerFrame:SetColorRGB(colorTask.r, colorTask.g, colorTask.b);
	ColorPickerFrame.previousValues = {r = colorTask.r, g = colorTask.g, b = colorTask.b, opacity = colorTask.opacity};
	ColorPickerFrame.cancelFunc = colorTask.cancelFunc;
	HideUIPanel(KhaosFrame);
	ShowUIPanel(ColorPickerFrame);
end

function KhaosConfig_ColorPicker_OnLoad()
	this.onClick = KhaosConfig_ColorPicker_OnClick;
	this.onEnter = KhaosConfig_ColorPicker_OnEnter;
	this.onLeave = KhaosConfig_ColorPicker_OnLeave;
end
function KhaosConfig_ColorPicker_OnClick()
	KhaosConfig_Action("COLORPICKER_CLICK", this:GetParent():GetID());
end
function KhaosConfig_ColorPicker_OnEnter()
	KhaosConfig_Action("COLORPICKER_ENTER", this:GetParent():GetID());
end
function KhaosConfig_ColorPicker_OnLeave()
	KhaosConfig_Action("COLORPICKER_LEAVE", this:GetParent():GetID());
end

--------------------------------------------------
-- Pulldowns
--------------------------------------------------
function KhaosConfig_Pulldown_OnLoad()
	this.onClick = KhaosConfig_Pulldown_OnClick;
	this.onEnter = KhaosConfig_Pulldown_OnEnter;
	this.onLeave = KhaosConfig_Pulldown_OnLeave;
	this.onMouseWheel = KhaosConfig_OnMouseWheel;
end
function KhaosConfig_Pulldown_OnClick()
	KhaosConfig_Action("PULLDOWN_CLICK", this:GetParent():GetID());
end
function KhaosConfig_Pulldown_OnEnter()
	KhaosConfig_Action("PULLDOWN_ENTER", this:GetParent():GetID());
end
function KhaosConfig_Pulldown_OnLeave()
	KhaosConfig_Action("PULLDOWN_LEAVE", this:GetParent():GetID());
end

--------------------------------------------------
-- Text Input Boxes
--------------------------------------------------
function KhaosConfig_TextInput_OnLoad()
	this.onEnterPressed 	= KhaosConfig_TextInput_OnEnterPressed;
	this.onEscapePressed 	= KhaosConfig_TextInput_OnEscapePressed;
	this.onSpacePressed 	= KhaosConfig_TextInput_OnSpacePressed;
	this.onTabPressed 	= KhaosConfig_TextInput_OnTabPressed;
	this.onTextChanged 	= KhaosConfig_TextInput_OnTextChanged;
	this.onTextSet  	= KhaosConfig_TextInput_OnTextSet;
	this.Enable 	= KhaosConfig_TextInput_Enable;
	this.Disable  	= KhaosConfig_TextInput_Disable;
	this.onMouseWheel = KhaosConfig_OnMouseWheel;
end

function KhaosConfig_TextInput_OnEnterPressed()
	KhaosConfig_Action("TEXT_PRESSED_ENTER", this:GetParent():GetID(), this:GetText()); 
end
function KhaosConfig_TextInput_OnEscapePressed()
	KhaosConfig_Action("TEXT_PRESSED_ESCAPE", this:GetParent():GetID(), this:GetText());
	this:ClearFocus();
end
function KhaosConfig_TextInput_OnSpacePressed()
	KhaosConfig_Action("TEXT_PRESSED_SPACE", this:GetParent():GetID(), this:GetText());
end
function KhaosConfig_TextInput_OnTabPressed()
	KhaosConfig_Action("TEXT_PRESSED_TAB", this:GetParent():GetID(), this:GetText());
end
function KhaosConfig_TextInput_OnTextChanged()
	KhaosConfig_Action("TEXT_CHANGED", this:GetParent():GetID(), this:GetText());
end
function KhaosConfig_TextInput_OnTextSet()
	KhaosConfig_Action("TEXT_SET", this:GetParent():GetID(), this:GetText());
end
function KhaosConfig_TextInput_Disable(this)
	if ( not this.disabled ) then
		this.disabled = true;
		this.lockValue = this:GetText();
		this.oldTextChanged = this.onTextChanged;
		this.onTextChanged = function () this:SetText(this.lockValue); end;
		this:SetTextColor(.5,.5,.5);
	end
end
function KhaosConfig_TextInput_Enable(this)
	if ( this.disabled ) then 
		this.disabled = nil;
		this:SetText(this.lockValue);
		this.onTextChanged = this.oldTextChanged;
		this:SetTextColor(1,1,1);
	end
end

--------------------------------------------------
-- Help Icon
--------------------------------------------------
function KhaosConfig_HelpIcon_OnLoad()
	this.onEnter = KhaosConfig_HelpIcon_OnEnter;
	this.onLeave = KhaosConfig_HelpIcon_OnLeave;
end
function KhaosConfig_HelpIcon_OnEnter()
	EarthTooltip:SetOwner(this, "ANCHOR_LEFT");
	EarthTooltip:SetText(KHAOS_HELP_TIP);
end	
function KhaosConfig_HelpIcon_OnLeave()
	EarthTooltip:Hide();
end
--------------------------------------------------
-- Khaos Login Selection Screen
--------------------------------------------------
function Khaos_Login_Frame_OnLoad()
	Chronos.afterInit(Khaos_Login_AfterInit);
	this.onShow = Khaos_Login_Frame_OnShow;
end

function Khaos_Login_Frame_OnShow()
	if ( not KhaosFrame.variablesLoaded ) then 
		Chronos.schedule(.1,Khaos_Login_Frame_OnShow);
		return;
	end
	local buttonName = "ConfigLock";
	local base = "KhaosLoginSelectionFrame";
	local button = getglobal(base..buttonName);
	local locale = GetLocale();
	local realm = GetCVar("realmName");
	local character = UnitName("player");
	local classText, class = UnitClass("player");

	if ( character ) then 
		getglobal(button:GetName().."Text"):SetText(string.format(KHAOS_LOGIN_LOCK_MESSAGE, character ) );
	end

	-- Add the current Character
	KhaosCore.addCharacter( realm, character, class, classText );

	-- Update the keywords
	KhaosCore.updateKeywords(realm, character, class, classText );

	local configs = KhaosCore.matchKeywords ( { player = character; realm = realm; class = class } ); 

	-- ### Load the most likely config's name	
	KhaosCore.loadConfiguration(configs[1].id);

	Khaos_Login_SyncSelected(configs[1].id);
	
end

-- Syncs the checkbox and edit text against the specified ID
function Khaos_Login_SyncSelected(testId)
	local locale = GetLocale();
	local realm = GetCVar("realmName");
	local character = UnitName("player");
	local buttonName = "ConfigLock";
	local base = "KhaosLoginSelectionFrame";
	local button = getglobal(base..buttonName);

	if ( Khaos_Configurations[testId] ) then 
		getglobal(base.."ConfigurationSelectText"):SetText(Khaos_Configurations[testId].name);
	else
		getglobal(base.."ConfigurationSelectText"):SetText(testId);
	end

	-- Set the checkbox if the most likely one is the locked one!
	if ( Khaos_Configuration_Locks[locale] ) then 
		if ( Khaos_Configuration_Locks[locale][realm] ) then 
			if ( Khaos_Configuration_Locks[locale][realm][character] ) then 
				local id = Khaos_Configuration_Locks[locale][realm][character];

				if ( id == testId) then 
					button:SetChecked(1);
				else
					button:SetChecked(nil);
				end
			end
		end
	end
end

-- Sets the players configuration lock
function Khaos_Login_SetConfigurationLock(id)
	local locale = GetLocale();
	local realm = GetCVar("realmName");
	local character = UnitName("player");
	local classText, class = UnitClass("player");

	if ( not Khaos_Configuration_Locks ) then 
		Khaos_Configuration_Locks = {};
	end
	if ( not Khaos_Configuration_Locks[locale] ) then 
		Khaos_Configuration_Locks[locale] = {};
	end
	if ( not Khaos_Configuration_Locks[locale][realm] ) then 
		Khaos_Configuration_Locks[locale][realm] = {};
	end
	
	Khaos_Configuration_Locks[locale][realm][character] = id;
	KhaosCore.updateKeywords( realm, character, class, classText );
end

-- On load
function Khaos_Login_ConfigLock_OnLoad()
	this.onClick = Khaos_Login_ConfigLock_OnClick;
end

-- Syncs the menu 
function Khaos_Login_ConfigLock_OnClick()
	if ( this:GetChecked() ) then 
		local id = KhaosCore.getActiveConfigurationID();
		Khaos_Login_SetConfigurationLock(id);
	else
		Khaos_Login_SetConfigurationLock(nil);
	end
end

-- Displays a menu of the possible configurations
function Khaos_Login_ShowConfigurationsMenu()

	local locale = GetLocale();
	local realm = GetCVar("realmName");
	local character = UnitName("player");
	local ignore, class = UnitClass("player");

	local configs;
	
	configs = KhaosCore.matchKeywords ( { player = character; realm = realm; class = class } ); 

	local active = KhaosCore.getActiveConfigurationID();
	local menu = {};
	local item = nil;
	for i=1,table.getn(configs) do 
		local id = configs[i].id;
		if ( Khaos_Configurations[id] ) then 
			item = {};
			item.text = Khaos_Configurations[id].name;
			item.value = id;
			item.func = function (checked, value)
				KhaosCore.saveConfiguration();
				KhaosCore.loadConfiguration(value);
				Khaos_Login_SyncSelected(value);
				
			end;
			if ( id == active ) then 
				item.checked = true;
			end;
			table.insert(menu,item);
		end
	end

	EarthMenu_MenuOpen(menu, this:GetName(), 0, 0, nil, 3, "TOPLEFT");
end
function Khaos_Login_AfterInit()
	if ( not KhaosFrame.variablesLoaded ) then 
		Chronos.schedule(3,Khaos_Login_AfterInit);
		return;
	end

	local locale = GetLocale();
	local realm = GetCVar("realmName");
	local character = UnitName("player");
	local classText, class = UnitClass("player");

	if ( not Khaos_Configuration_Locks ) then 
		Khaos_Configuration_Locks = {};
	end

	-- Add this stuff to the current tables
	KhaosCore.addCharacter( realm, character, class, classText );
	KhaosCore.updateKeywords( realm, character, class, classText );

	local count = 0;
	for k,v in Khaos_Configurations do 
		count = count + 1;
	end

	-- Simple Block Loader
	if ( count == 1 ) then 
		KhaosCore.loadConfiguration(1);	
		return;
	elseif ( count == 0 ) then
		KhaosCore.createConfiguration(KHAOS_DEFAULT_CONFIGURATION_NAME, {default=true});
		local id = KhaosCore.copyConfiguration(1);

		Khaos_Configurations[id].name=KHAOS_EMPTY_CONFIGURATION_NAME;
		for k,v in Khaos_Configurations[id].configuration.sets do 
			Khaos_Configurations[id].configuration.sets[k] = false;
		end

		KhaosCore.loadConfiguration(1);
		ShowUIPanel(KhaosFrame);
		return;
	elseif ( Khaos_Configuration_Locks[locale] ) then 
		if ( Khaos_Configuration_Locks[locale][realm] ) then 
			if ( Khaos_Configuration_Locks[locale][realm][character] ) then 
				local id = Khaos_Configuration_Locks[locale][realm][character];
				if ( Khaos_Configurations[id] ) then 
					KhaosCore.loadConfiguration(id);
					return;
				end
			end
		end
	end

	KhaosLoginSelectionFrame:Show();
end
--------------------------------------------------
-- Login Help Icon
--------------------------------------------------
function KhaosConfig_Login_HelpIcon_OnLoad()
	this.onEnter = KhaosConfig_Login_HelpIcon_OnEnter;
	this.onLeave = KhaosConfig_Login_HelpIcon_OnLeave;
end
function KhaosConfig_Login_HelpIcon_OnEnter()
	EarthTooltip:SetOwner(this, "ANCHOR_LEFT");
	EarthTooltip:SetText(KHAOS_LOGIN_SELECT_HELP_MESSAGE);
end	
function KhaosConfig_Login_HelpIcon_OnLeave()
	EarthTooltip:Hide();
end

--------------------------------------------------
-- Khaos Config Miscellaneous
--------------------------------------------------
function KhaosConfig_SelectMenu_OnLoad()
	this.onClick = KhaosConfig_SelectMenu_OnClick;
end
function KhaosConfig_SelectMenu_OnClick()
	KhaosConfig_Config_OpenMenu(KhaosCore.getActiveConfigurationID());
end
function KhaosConfig_Config_OnClick(value)
	if ( arg1 == "LeftButton" ) then 
		KhaosConfig_LoadConfigurationIntoGui(value);
	else
		KhaosConfig_Config_OpenMenu(value);
	end
end

function KhaosConfig_Config_GetMenu(value)
	local name = "Configuration";
	local menu = {};

	if ( Khaos_Configurations[value] ) then 
		name = Khaos_Configurations[value].name;
	end

	local item = {};
	item.text = string.format(KHAOS_CONFIG_MENU_RENAME,name);
	item.value = value;
	item.keepShownOnClick = false;
	item.notCheckable = true;
	item.func = KhaosConfig_Config_Menu_RenameConfiguration;
	table.insert(menu, item);

	item = {};
	item.text = string.format(KHAOS_CONFIG_MENU_COPY,name);
	item.value = value;
	item.keepShownOnClick = false;
	item.notCheckable = true;
	item.func = KhaosConfig_Config_Menu_CopyConfiguration;
	table.insert(menu, item);

	if (table.getn(Khaos_Configurations) > 1) then 
		item = {};
		item.text = string.format(KHAOS_CONFIG_MENU_DELETE,name); 
		item.value = value;
		item.keepShownOnClick = false;
		item.notCheckable = true;
		item.func = KhaosConfig_Config_Menu_DeleteConfiguration;
		table.insert(menu, item);
	end

	item = {};
	item.text = string.format(KHAOS_CONFIG_MENU_EXPORT,name);
	item.value = value;
	item.keepShownOnClick = false;
	item.notCheckable = true;
	item.func = KhaosConfig_Config_Menu_ExportConfiguration;
	table.insert(menu, item);

	item = {};
	item.text = KHAOS_CONFIG_MENU_IMPORT;
	item.value = value;
	item.keepShownOnClick = false;
	item.notCheckable = true;
	item.func = KhaosConfig_Config_Menu_ImportConfiguration;
	table.insert(menu, item);

	item = {};
	item.text = KHAOS_CONFIG_MENU_NEW;
	item.value = value;
	item.keepShownOnClick = false;
	item.notCheckable = true;
	item.func = KhaosConfig_Config_Menu_NewConfiguration;
	table.insert(menu, item);

	item = {};
	item.text = KHAOS_CONFIG_MENU_CHANGE_DEFAULT;
	item.value = value;
	item.keepShownOnClick = false;
	item.notCheckable = true;
	item.func = KhaosConfig_Config_Menu_ChangeDefault;
	table.insert(menu, item);
	
	return menu;
end

function KhaosConfig_Config_OpenMenu(value)
	local menu = KhaosConfig_Config_GetMenu(value);	
	EarthMenu_MenuOpen(menu, this:GetName(), 0, 0, "MENU");	
end

function KhaosConfig_ConfigHeader_OnClick(value)
	if ( arg1 == "LeftButton" ) then 
	else
		KhaosConfig_ConfigHeader_OpenMenu(value);
	end
end

function KhaosConfig_ConfigHeader_OpenMenu() 
	local menu = {};

	item = {};
	item.text = KHAOS_CONFIG_MENU_NEW;
	item.keepShownOnClick = false;
	item.func = KhaosConfig_Config_Menu_NewConfiguration;
	table.insert(menu, item);
end

function KhaosConfig_Config_Menu_NewConfiguration(checked, value)
	Earth_Popup(
		{
			text = KHAOS_CONFIG_PROMPT_NEW_TEXT;
			
			leftButton = KHAOS_CONFIG_PROMPT_NEW_ACCEPT;
			rightButton = KHAOS_CONFIG_PROMPT_NEW_CANCEL;
			onLeft = KhaosConfig_Config_Menu_NewConfiguration_Create;
			
			hasEditBox = true;
			editBoxLength = 30;
			editBoxText = KHAOS_DEFAULT_CONFIGURATION_NAME;
			onEnterPressed = KhaosConfig_Config_Menu_NewConfiguration_Create;
			autoFocus = true;			
		}
	);
end

function KhaosConfig_Config_Menu_NewConfiguration_Create ( name )
	KhaosCore.createConfiguration(name);
	Khaos.refresh();
end

function KhaosConfig_Config_Menu_ExportConfiguration ( checked, value )
	local preText = Khaos_Configurations[value];
	
	local text = Sea.string.objectToString(preText);
	getglobal("KhaosImportExportFrameScrollFrameText"):SetText(text);
	getglobal("KhaosImportExportFrameScrollFrameText"):HighlightText(0,string.len(text));
	getglobal("KhaosImportExportFrameSelectAllButton"):Show();
	getglobal("KhaosImportExportFrameImportButton"):Hide();
	getglobal("KhaosImportExportFrameText"):SetText(KHAOS_EXPORT_MESSAGE);
	getglobal("KhaosImportExportFrameText"):SetPoint("TOP", "KhaosImportExportFrame", "TOP", 0, 10);
	getglobal("KhaosImportExportFrame"):Show();
	HideUIPanel(KhaosFrame);
end


function KhaosConfig_Config_Menu_ImportConfiguration ( )
	getglobal("KhaosImportExportFrameSelectAllButton"):Hide();
	getglobal("KhaosImportExportFrameImportButton"):Show();
	getglobal("KhaosImportExportFrameText"):SetPoint("TOP", "KhaosImportExportFrame", "TOP", 0, 32);
	getglobal("KhaosImportExportFrameText"):SetText(KHAOS_IMPORT_MESSAGE);
	getglobal("KhaosImportExportFrame"):Show();
	HideUIPanel(KhaosFrame);
end

function KhaosConfig_Config_Menu_DeleteConfiguration(checked, value)
	local name = "Unnamed Configuration";
	
	if ( Khaos_Configurations[value] ) then 
		name = Khaos_Configurations[value].name;
	end

	Earth_Popup(
		{
			text = string.format(KHAOS_CONFIG_PROMPT_DELETE_TEXT, name);
			
			leftButton = KHAOS_CONFIG_PROMPT_DELETE_ACCEPT;
			rightButton = KHAOS_CONFIG_PROMPT_DELETE_CANCEL;
			onLeft = function() KhaosConfig_Config_Menu_DeleteConfiguration_Delete(value) end;
		}
	);
end

function KhaosConfig_Config_Menu_DeleteConfiguration_Delete (value)
	KhaosCore.deleteConfiguration(value);
	Khaos.refresh();
end

function KhaosConfig_Config_Menu_CopyConfiguration(checked, value)
	local name = "Unnamed Configuration";
	
	if ( Khaos_Configurations[value] ) then 
		name = Khaos_Configurations[value].name;
	end

	Earth_Popup(
		{
			text = string.format(KHAOS_CONFIG_PROMPT_COPY_TEXT, name);
			
			leftButton = KHAOS_CONFIG_PROMPT_COPY_ACCEPT;
			rightButton = KHAOS_CONFIG_PROMPT_COPY_CANCEL;
			onLeft = function() KhaosConfig_Config_Menu_CopyConfiguration_Copy(value) end;
		}
	);
end

function KhaosConfig_Config_Menu_CopyConfiguration_Copy (value)
	KhaosCore.copyConfiguration(value);
	Khaos.refresh();
end

function KhaosConfig_Config_Menu_ChangeDefault()
	getglobal("KhaosLoginSelectionFrame"):Show();
	HideUIPanel(KhaosFrame);
end

function KhaosConfig_Config_Menu_RenameConfiguration(checked, value)
	local name = "Unnamed Configuration";
	
	if ( Khaos_Configurations[value] and Khaos_Configurations[value].name ) then 
		name = Khaos_Configurations[value].name;
	end

	Earth_Popup(
		{
			text = string.format(KHAOS_CONFIG_PROMPT_RENAME_TEXT, name);
			
			leftButton = KHAOS_CONFIG_PROMPT_RENAME_ACCEPT;
			rightButton = KHAOS_CONFIG_PROMPT_RENAME_CANCEL;
			onLeft = function(newname) KhaosConfig_Config_Menu_RenameConfiguration_Rename(value, newname) end;
			
			hasEditBox = true;
			editBoxLength = 30;
			editBoxText = name;
			onEnterPressed = function(newname) KhaosConfig_Config_Menu_RenameConfiguration_Rename(value, newname) end;
			autoFocus = true;			
		}
	);
end

function KhaosConfig_Config_Menu_RenameConfiguration_Rename (id, name)
	KhaosCore.renameConfiguration(id, name);
	Khaos.refresh();
end

function KhaosConfig_Loader_OnCheck(checked, value)
	Sea.io.print(string.format(KHAOS_LOADING_MESSAGE, value, KHAOS_LOAD_COUNT));
	Chronos.schedule(KHAOS_LOAD_COUNT, KhaosCore.loadAddOn, value);
	Chronos.schedule(KHAOS_LOAD_COUNT+0.5, Khaos.refresh);
end

function KhaosConfig_Loader_OnClick(value)
end

function KhaosConfig_Enabler_OnCheck(checked, value)
	name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(value);
	if ( checked ) then 
		if ( not enabled ) then 
			if ( loadable ) then 
				Sea.io.print(string.format(KHAOS_ENABLE_LOADABLE, title));
				EnableAddOn(value);
			else
				Sea.io.print(string.format(KHAOS_ENABLE_UNLOADABLE,title));
				EnableAddOn(value);
			end
		else
			Sea.io.print(string.format(KHAOS_ENABLE_ALREADY,title));
		end
	else
		Sea.io.print(string.format(KHAOS_ENABLE_DISABLE, title));
		DisableAddOn(value);
	end
end

function KhaosConfig_Enabler_OnClick(value)
	
end

function KhaosConfig_SetCheck_OnClick(checked, value)
	if ( checked ) then 
		checked = true;
	else
		checked = false;
	end
	Khaos.setSetEnabled(value, checked);
	KhaosConfig_UpdateOptionPane();
	Khaos.refresh(false, false, true);
end

function KhaosConfig_Set_OnClick(value)
	if ( arg1 == "LeftButton" ) then
		if ( value ~= KhaosCore.getCurrentSet() ) then
			KhaosCore.setOffset(0); -- ### Come consider this later.
			KhaosCore.setCurrentSet(value);
			Khaos.refresh(false,false,true);
		end
	else
		KhaosConfig_Set_OpenMenu(value);
	end
end

function KhaosConfig_Set_OpenMenu(value) 
	local menu = {};
	local enabled = Khaos.getSetEnabled(value);
	local item = {};

	item.text = KHAOS_SET_MENU_ENABLE;
	item.value = value;
	item.keepShownOnClick = true;
	item.checked = enabled;
	item.func = function(checked, value) if ( checked == 1 ) then checked = true; else checked=false; end  Khaos.setSetEnabled(value, checked); Khaos.refresh(nil, nil, true) end;
	menu[1] = item;

	item = {};
	item.text = KHAOS_SET_MENU_RESET; 
	item.value = value;
	item.func = function (checked, value) KhaosCore.resetSet(value); Khaos.refresh(nil, nil, true); end;
	menu[2] = item;

	EarthMenu_MenuOpen(menu, this:GetName(), 0, 0, "MENU");	
end

--[[ Resets the current set ]]-- 
function KhaosConfig_Set_ResetCurrentSet()
	KhaosCore.resetSet( KhaosCore.getCurrentSet() );
	Khaos.refresh();
end

--[[ Difficulty Button ]]--
function KhaosConfig_DifficultyButton_OnLoad()
	this.onClick = KhaosConfig_DifficultyButton_OnClick;
end

function KhaosConfig_DifficultyButton_OnClick()
	local menulist = KhaosConfig_CreateDifficultyMenu();
	EarthMenu_MenuOpen(menulist, this:GetName(), 0, 0, "MENU");	
end

--[[ TableOfContents Button ]]--
function KhaosConfig_TableOfContentsButton_OnLoad()
this.onClick = KhaosConfig_TableOfContentsButton_OnClick;
end

function KhaosConfig_TableOfContentsButton_OnClick()
local menulist = KhaosConfig_CreateTocMenu();
EarthMenu_MenuOpen(menulist, this:GetName(), 30, 0, "MENU", nil, "TOPRIGHT");	
end

--------------------------------------------------
-- Tab Buttons
--------------------------------------------------

function Khaos_Tab_OnShow(tab)
local id = tab:GetID();
local texture = getglobal(tab:GetName().."Icon");
if ( texture ) then 
	if ( Khaos_Select_Groups[id].texture ~= "#Player#" ) then 
		texture:SetTexture(Khaos_Select_Groups[id].texture);
		texture:SetTexCoord(6/32,26/32,32/64,58/64);
	else
		SetPortraitTexture(texture, "player");
		texture:SetTexCoord(0.2,0.9,0.0666,0.9);
	end
end
end

function Khaos_Tab_OnClick()
PlaySound("igMainMenuOptionCheckBoxOn");

local id = this:GetID();
KhaosData.configurationTab = id;
Khaos.refresh();
end

function Khaos_Tab_OnEnter()
local id = this:GetID();	
EarthTooltip:SetOwner(this, "ANCHOR_RIGHT");
EarthTooltip:SetText(Khaos_Select_Groups[id].label);
end

function Khaos_Tab_OnLeave()
EarthTooltip:Hide();	
end

--------------------------------------------------
-- Import/Export Frame
--------------------------------------------------
function Khaos_Import_Import_OnClick ()
local text = getglobal(this:GetParent():GetName().."ScrollFrameText"):GetText();
local newCfg = Sea.string.stringToObject(text);

if ( newCfg ) then 
	table.insert(Khaos_Configurations, newCfg);
end

this:GetParent():Hide();
ShowUIPanel(KhaosFrame);
end

function Khaos_Import_SelectAll_OnClick ()
local text = getglobal(this:GetParent():GetName().."ScrollFrameText"):GetText();
getglobal(this:GetParent():GetName().."ScrollFrameText"):HighlightText(0,string.len(text));
end

function Khaos_Import_Close_OnClick ()
this:GetParent():Hide();
getglobal("KhaosFrame"):Show();
end

--------------------------------------------------
-- Main Frame
--------------------------------------------------

function Khaos_Frame_OnLoad()
this.onShow = Khaos_Frame_OnShow;

-- Frame Properties
this.numTabs = 5;
this.selectedTab = 1;
getglobal(this:GetName().."HeaderText"):SetText(KHAOS_TITLE_TEXT);

EarthPanelTemplates_Vertical_SetTab(this, 1);
KhaosFrameConfigurationSelectPaneContainerTree.collapseAllButton = false;
KhaosFrameConfigurationSelectPaneContainerTree.collapseAllArtwork = false;
KhaosFrameConfigurationSelectPaneContainerTree.tooltipPlacement = "cursor";
KhaosFrameConfigurationSelectPaneContainerTree.tooltipAnchor = "ANCHOR_RIGHT";
KhaosFrameSetSelectPaneContainerTree.tooltipPlacement = "frame";
KhaosFrameSetSelectPaneContainerTree.tooltipAnchor = "ANCHOR_BOTTOMRIGHT";

--KhaosFrameResetButton:Disable();
KhaosFrameTableOfContentsButton:Disable();

-- Add to the UIPanelWindows
UIPanelWindows["KhaosFrame"] = { area = "center",	pushable = 0 };

-- Initialize the Default Folder
KhaosConfig_RegisterInit();

-- Demo stuff
--KhaosConfig_RegisterDemo();

Chronos.afterInit(function() Chronos.schedule(.5,KhaosCore.runCallbacks); end);
end

function Khaos_EventFrame_OnLoad()
this:RegisterEvent("VARIABLES_LOADED");
this:RegisterEvent("ADDON_LOADED");
this.onEvent= Khaos_Frame_OnEvent;
end

function Khaos_Frame_OnShow()
-- Update the Tab Icons
local i = 1;
local tab = getglobal(this:GetName().."Tab"..i);
while ( tab ) do
	Khaos_Tab_OnShow(tab);
	i = i + 1;
	tab = getglobal(this:GetName().."Tab"..i);
end

Khaos_Frame_DifficultyUpdate();		

-- Update the config list
KhaosConfig_UpdateActiveBanner();
KhaosConfig_ChangeConfigList(this.selectedTab);
Khaos.refresh();
end

function Khaos_Frame_DifficultyUpdate()
if ( KhaosCore.getDifficulty() < 2 ) then
	KhaosFrameConfigurationSelectPane:Hide();
	KhaosFrameConfigurationSelectMenu:Hide();
	for i=1,5 do 
		getglobal("KhaosFrameTab"..i):Hide();
	end
	KhaosFrameConfigurationSelectPane:SetPoint("TOPLEFT", "KhaosFrame", "TOPLEFT", 40 - KhaosFrameConfigurationSelectPane:GetWidth() , -58);
	KhaosFrame:SetWidth(860 - KhaosFrameConfigurationSelectPane:GetWidth() );
else
	KhaosFrame:SetWidth(860);
	KhaosFrameConfigurationSelectPane:SetPoint("TOPLEFT", "KhaosFrame", "TOPLEFT", 40, -58);
	KhaosFrameConfigurationSelectPane:Show();
	KhaosFrameConfigurationSelectMenu:Show();
	for i=1,5 do 
		getglobal("KhaosFrameTab"..i):Show();
	end
end
end

function Khaos_Frame_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		KhaosFrame.variablesLoaded = true;
		Chronos.schedule(5, KhaosCore.runCallbacks);
	end
	if ( event == "ADDON_LOADED" and KhaosFrame.variablesLoaded ) then 
		Chronos.schedule(5, KhaosCore.runCallbacks);
	end
end

-- Initialization Code
function KhaosConfig_RegisterInit()
Khaos.registerFolder( 
	{
		id = "other";
		text = KHAOS_FOLDER_DEFAULT;
		helptext = KHAOS_FOLDER_DEFAULT_HELP;
		difficulty = 1;
	},
	{
		id = "bars";
		text = KHAOS_FOLDER_BARS;
		helptext = KHAOS_FOLDER_BARS_HELP;
		difficulty = 1;
	},
	{
		id = "chat";
		text = KHAOS_FOLDER_CHAT;
		helptext = KHAOS_FOLDER_CHAT_HELP;
		difficulty = 1;
	},
	{
		id = "class";
		text = KHAOS_FOLDER_CLASS;
		helptext = KHAOS_FOLDER_CLASS_HELP;
		difficulty = 2;
	},
	{
		id = "combat";
		text = KHAOS_FOLDER_COMBAT;
		helptext = KHAOS_FOLDER_COMBAT_HELP;
		difficulty = 1;
	},
	{
		id = "comm";
		text = KHAOS_FOLDER_COMM;
		helptext = KHAOS_FOLDER_COMM_HELP;
		difficulty = 1;
	},
	{
		id = "frames";
		text = KHAOS_FOLDER_FRAMES;
		helptext = KHAOS_FOLDER_FRAMES_HELP;
		difficulty = 1;
	},
	{
		id = "inventory";
		text = KHAOS_FOLDER_INVENTORY;
		helptext = KHAOS_FOLDER_INVENTORY_HELP;
		difficulty = 1;
	},
	{
		id = "maps";
		text = KHAOS_FOLDER_MAPS;
		helptext = KHAOS_FOLDER_MAPS_HELP;
		difficulty = 1;
	},
	{
		id = "quest";
		text = KHAOS_FOLDER_QUEST;
		helptext = KHAOS_FOLDER_QUEST_HELP;
		difficulty = 1;
	},
	{
		id = "social";
		text = KHAOS_FOLDER_SOCIAL;
		helptext = KHAOS_FOLDER_SOCIAL_HELP;
		difficulty = 2;
	},
	{
		id = "tooltip";
		text = KHAOS_FOLDER_TOOLTIP;
		helptext = KHAOS_FOLDER_TOOLTIP_HELP;
		difficulty = 1;
	},
	{
		id = "debug";
		text = KHAOS_FOLDER_DEBUG;
		helptext = KHAOS_FOLDER_DEBUG_HELP;
		difficulty = 4;
	}
);

EarthFeature_AddButton (
	{
		id = "Khaos",
		name = KHAOS_TITLE_TEXT, 
		subtext = KHAOS_BUTTON_SUB,
		tooltip = KHAOS_BUTTON_TIP, 
		icon = "Interface\\Icons\\Ability_Repair", 
		callback = function()
			if (KhaosFrame:IsVisible()) then 
				HideUIPanel(KhaosFrame);
			else 
				PlaySound("igMainMenuOption");
				ShowUIPanel(KhaosFrame);
			end
		end
	}
);	
end

--------------------------------------------------
--
-- Demo Code
-- 
--------------------------------------------------

function KhaosConfig_RegisterDemo()
Khaos.registerFolder( 
	{
		id = "bar";
		text = "Bars";
		helptext = "Optional Bars of Power";
		difficulty = 1;
	},
	{
		id = "class";
		text = "Class Helpers";
		helptext = "Tools of immense power";
		difficulty = 2;
	},
	{
		id = "comm";
		text = "Communication";
		helptext = "Communication of many types";
		difficulty = 2;
	},
	{
		id = "quest";
		text = "Quests";
		helptext = "Quest affecting mods";
		difficulty = 2;
	},
	{
		id = "zoz";
		text = "Zoobar";
		helptext = "Faslascasdf";
		difficulty = 2;
	},
	{
		id = "yxz";
		text = "ZyxZyX";
		helptext = "Too High";
		difficulty = 3;
	},
	{
		id = "debug";
		text = "Debug Tools";
		helptext = "I love these";
		difficulty = 4;
	}
);

local radioTestCallback = function (state)
	if ( state.value == "green" ) then
		Sea.io.print("Bars are green!!");
	elseif ( state.value == "red" ) then
		Sea.io.print("Bars are red!");
	else
		Sea.io.print("Bars are some other color!");
	end
end;
local radioTestFeedback = function(state)
	if ( state.value == "green" ) then
		return "You have green bars.";
	elseif ( state.value == "red" ) then
		return "You have red bars.";
	else
		return "Your bars are "..state.value..".";
	end
end;
local radioTestDefault = {
	value = "green";
};
local radioTestDisabled = {
	value = "red";
};

Khaos.registerOptionSet(
	"bar",
	{
		id="BlizzardBars";
		text="Blizzard Bars";
		helptext="Blizzard's Default Bars - Better!";
		difficulty=1;
		options = {
			{
				id="BlizzBarHeader";
				text="Blizzard Bar Location";
				helptext="These options relocate the Blizzard bars to nicer locations.";
				type = K_HEADER;
			};
			{
				id="SwapBarRight";
				text="Move Right Bar";
				helptext="These options relocate the Blizzard right bars to nicer locations.";
				type = K_TEXT;
				key = "BlizSwapRight";
				value = true;
				check = true;
				callback = function(state)
					if ( state.checked ) then
						Sea.io.print("Checked! Right Bars move to the left!");
					else
						Sea.io.print("Unchecked! Right Bars move to the original spot");
					end
				end;
				feedback = function(state)
					if ( state.checked ) then
						return "Right Bars are attached to the left";
					else
						return "Right Bars are attached to the right";
					end
				end;
				default = {
					checked = true;
				};
				disabled = {
					checked = false;
				};
			};
			{

				id="SwapBarLeft";
				key="BlizSwapLeft";
				value=true;
				text="Move Left Bar";
				helptext="Moves the left extra bar to the left side of the screen.";
				type = K_SLIDER;
				check = true;
				setup = {
					sliderMin = -50;
					sliderMax = 100;
					sliderLowText = "Top";
					sliderHighText = "Bottom";
					sliderStep = 10;
					sliderText = "Vertical Offset";
					sliderDisplayFunc = function (state) return state.slider; end;						
				};
				callback = function(state)
					if ( state.checked ) then
						Sea.io.print("Checked! Bars move to the left!");
					else
						Sea.io.print("Unchecked! Bars move to the original spot");
					end
				end;
				feedback = function(state)
					if ( state.checked ) then
						return "Bars are attached to the left";
					else
						return "Bars are attached to the right";
					end
				end;
				default = {
					checked = true;
					slider = 10;
				};
				disabled = {
					checked = false;
					slider = 0;
				};
				dependencies = {
					["BlizSwapLeft"] = { checked=true; match=true;};
				};
			};
			{
				id="BlizzBarRadio1";
				text="Green Colored Bars";
				helptext="These options recolor";
				key = "TestRadio";
				value = "green";
				radio = true;
				type = K_TEXT;
				default = radioTestDefault;
				disabled = radioTestDisabled;
				callback = radioTestCallback;
				feedback = radioTestFeedback;
				setup = { 
					selectedColor={r=0,g=1,b=0};
					disabledColor={r=.5,g=.5,b=.5};
				}
			};
			--[[
				{
					id="BlizzBarRadio2";
					text="Red Colored Bars";
					helptext="These options recolor";
					key = "TestRadio";
					value = "red";
					radio = true;
					type = K_TEXT;
					default = radioTestDefault;
					disabled = radioTestDisabled;
					callback = radioTestCallback;
					feedback = radioTestFeedback;
					setup = { 
						selectedColor={r=1,g=0,b=0};
						disabledColor={r=.5,g=.5,b=.5};
					}
				};
				]]
				{
					id="BlizzBarRadio2";
					text="Blue Colored Bars";
					helptext="These options recolor the bars";
					key = "TestRadio";
					value = "blue";
					radio = true;
					type = K_TEXT;
					default = radioTestDefault;
					disabled = radioTestDisabled;
					callback = radioTestCallback;
					feedback = radioTestFeedback;
					setup = { 
						selectedColor={r=.2,g=2,b=1};
						disabledColor={r=.5,g=.5,b=.5};
					}
				};
				{
					id="BlizzardBarReset";
					text="Clear all bars";
					helptext="Will remove the action keys from all bars";
					type = K_BUTTON;
					callback = function()
						Sea.io.print("You reset! All your bars were cleared.");
					end;
					setup = {
						buttonText = "Clear";
					};
				};
				{
					id="BlizzardBarPulldown";
					key="BBPulldowns";
					text="Select Recolored Bar";
					helptext="Select which bars you want affected by the recoloring";
					type = K_PULLDOWN;
					callback = function(state)
						Sea.io.print("You've selected which bar will be affected!");
					end;
					feedback = function (state)
						local vals = "";

						for k,v in state.value do
							vals = vals.." "..v;
						end

						return vals.." is selected.";
					end;
					setup = {
						options={
							["Left Bar"] = "Left";
							["Right Bar"] = "Right";
							["Top Bar"] = "Top";
							["Bottom Bar"] = "Bottom";
						};
						multiSelect=false;
					};
					default = {
						value = "Left";
					};
					disabled = {
						value = nil;
					};
				};
				{
					id="BlizzardBarPulldown2";
					key="BBPulldowns2";
					text="Select Movable Bars";
					helptext="Select which bars you want to move";
					type = K_PULLDOWN;
					callback = function(state)
						Sea.io.printTable(state);
						Sea.io.print("You've selected which bar will be affected!");
					end;
					feedback = function (state)
						local vals = "";

						for k,v in state.value do
							vals = vals.." "..v;
						end

						return vals.." is selected.";
					end;
					setup = {
						options={
							["Left Bar"] = "Left";
							["Right Bar"] = "Right";
							["Top Bar"] = "Top";
							["Bottom Bar"] = "Bottom";
						};
						multiSelect=true;
					};
					default = {
						value = {"Left"};
					};
					disabled = {
						value = {};
					};
				};
				{
					id="BlizzardBarCommand";
					key="BBResetCommand";
					value={"/bbreset"};
					text="Enter reset slash command";
					helptext="Pick your own slash command";
					type = K_EDITBOX;
					callback = function(state)
						Sea.io.print("You've entered ", state.value);
					end;
					feedback = function (state)
						return state.value.." will call the reset!";
					end;
					setup = {
						callOn = {"enter"};
					};
					default = {
						value = "/bbreset";
					};
					disabled = {
						value = "/bbresetdisabled";
					};
				};
				{
					id="ZoneColor";
					key="ZoneColor";
					text="Zone Text Color";
					helptext="Pick a color for the zone text";
					type = K_COLORPICKER;
					callback = function(state)
						Sea.io.printc(state.color, "You've selected ", unpack(state.color) );
					end;
					feedback = function (state)
						return "You've selected a color!";
					end;
					setup = {
						hasOpacity = true;
					};
					default = {
						color = { r=1, g=1, b=0, opacity=.6 };
					};
					disabled = {
						color = { r=.8,g=.8,b=.8,opacity=.6 };
					};
				};
			};
			default = true;
		}
	);
	Khaos.registerOptionSet(
		"bar",
		{
			id="FlexBar";
			text="Flexbars";
			helptext="As flexible as you are";
			difficulty=3;
			options = {};
			default = false;
		}
	);
	Khaos.registerOptionSet(
		"bar",
		{
			id="PopBar";
			text="PopBars";
			helptext="They Pop when you click 'em";
			difficulty=2;
			options = {};
			default = false;			
		}
	);
	Khaos.registerOptionSet(
		"bar",
		{
			id = "2ndBar";
			text = "Second Bars";
			helptext="Easy Second Hand";
			difficulty = 1;
			options = {};
			default = true;
		}
	);

	Khaos.registerOptionSet(
		"classhelper",
		{
			id = "DivineBlessing";
			text = "Divine Blessing";
			helptext="Bless 'em all";
			difficulty = 3;
			options = {};
			default = false;
		}
	);
	Khaos.registerOptionSet(
		"classhelper",
		{
			id = "HealerHelper";
			text = "Healer Helper";
			helptext="Heal with the power of hotkeys";
			difficulty = 2;
			options = {};
			default = false;
		}
	);
	Khaos.registerOptionSet(
		"classhelper",
		{
			id = "RogueHelper";
			text = "Rogue Helper";
			helptext="Rogues do it from behind.";
			difficulty = 2;
			options = {};
			default = false;
		}
	);
	Khaos.registerOptionSet(
		"classhelper",
		{
			id = "ShardTracker";
			text = "Shard Tracker";
			helptext="Your soul is mine!";
			difficulty = 2;
			options = {};
			default = false;
		}
	);
	Khaos.registerOptionSet(
		"classhelper",
		{
			id = "TotemStomper";
			text = "Totem Stomper";
			helptext="Behold my fierce set!";
			difficulty = 3;
			options = {};
			default = false;
		}
	);
	
	-- Comm 
	Khaos.registerOptionSet(
		"comm",
		{
			id = "CombatCaller";
			text = "Combat Caller";
			helptext="Combat Time! Heal me!";
			difficulty = 1;
			options = {};
			default = true;
		}
	);
	Khaos.registerOptionSet(
		"comm",
		{
			id = "Pager";
			text = "Pager Power";
			helptext="STOP!!!!";
			difficulty = 2;
			options = {};
			default = true;
		}
	);
	Khaos.registerOptionSet(
		"comm",
		{
			id = "PetMon";
			text = "Pet Monitor";
			helptext="Displays a live frame on your pets health";
			difficulty = 2;
			options = {};
			default = true;
		}
	);
	Khaos.registerOptionSet(
		"comm",
		{
			id = "RaidMinion";
			text = "RaidMinion";
			helptext="See anyone anywhere anytime";
			difficulty = 3;
			options = {};
			default = true;
		}
	);

	-- Quests
	Khaos.registerOptionSet(
		"quest",
		{
			id = "PartyQuests";
			text = "PartyQuests";
			helptext="Who else has this quest?";
			difficulty = 1;
			options = {};
			default = true;
		}
	);

	Khaos.registerOptionSet(
		"quest",
		{
			id = "QuestMinion";
			text = "Quest Minion";
			helptext="How many items are left?";
			difficulty = 2;
			options = {};
			default = false;
		}
	);
	
	Khaos.registerOptionSet(
		"quest",
		{
			id = "QuestHelp";
			text = "QuestHelperr";
			helptext="Yarrrrr";
			difficulty = 3;
			options = {};
			default = false;
		}
	);

	Khaos.registerOptionSet(
		"zoz",
		{
			id = "Zaaz";
			text = "Zaaz";
			helptext="I dont care anymore";
			difficulty = 1;
			options = {};
		}
	);
	Khaos.registerOptionSet(
		"debug",
		{
			id = "Fooz";
			text = "Foozz";
			helptext="Life is wasted";
			difficulty = 4;
			options = {};
		}
	);

	Khaos.registerOptionSet(
		"zoz",
		{
			id = "Zzzzz";
			text = "ZZZzzzz";
			helptext="Want to sleep...";
			difficulty = 3;
			options = {};
		}
	);

end;

--[[
Khaos_ConfigSelect_Demo = {
	{
		title="My Configurations";
		children = {
			{
				title="Default Configurations";
				children = {
					{title = "Default Configuration";}
				};
			};
			{ 
				title="Class Configurations";
				children = {
					{title = "Simple Priest";},
					{title = "Advanced Priest";},
					{title = "Mage (Blackrock)";},
					{title = "Rhonia (Warlock)";}
				};
			};
			{
				title="Character Configurations";
				children = {
					{title = "Rhonia (Warlock)";}
				};
			};
			{
				title="Realm Configurations";
				children = {
					{title = "Blasted Server";},
					{title = "Mage (Blackrock)";},
					{title = "RP Server (Arthas)";}
				};
			}
		};
	}		
};
]]--

--------------------------------------------------
--
-- Type Definitions
--
--------------------------------------------------

--[[

	KhaosConfigurationFolder = {
		id = "AmazingFolderId";
		text = "Amazing AddOns";
		helptext = "These AddOns will do amazing things for you and all of your friends. ";
		difficulty = 5;  -- 1 - Easy as Pie, 5 - Most people can handle it, 10 - Lua addicts only
	}
		
	id - unique id for that folder
	text - short text description
	helptext - longer description for what addons belong in this folder
	difficulty - number to determine what level of user should be seeing this stuff.

--------------------------------------------------
	
	KhaosSet = {
		id = "MyConfigSetId";
		text = "My AddOn";
		helptext = "My AddOn does an amazing thing with awesome stuff. You should enable it.";
		difficulty = 6;
		default = true;
		callback = function(enabled) if ( enabled ) then Sea.io.print("My AddOn Activated"); end end;
		options = {
			{KhaosOption},
			{KhaosOption},
			...
			{KhaosOption}
		}
		commands = {
			{KhaosSlashCommand},
			{KhaosSlashCommand},
			...
			{KhaosSlashCommand}
		}
	}

	id - unique id for that folder
	text - short text description
	helptext - longer description for what addons belong in this folder
	difficuly - number to determine what level of user should be seeing this stuff.
	configs - a list of configurations associated with this configuration set. 
	default - true if the set options default to enabled, false if default disabled.
	callback - a function which will let you know when an entire addon is enabled/disabled
	
--------------------------------------------------

	KhaosSlashCommand = {
		id = "KhaosCommandDemo";
		commands = { "/khaoscomm", "/khcm" };
		parseTree = { KhaosParseTree };
		helpText = "Just a demo function.";
	}

	KhaosParseTree = {
		-- String keywords create branches
		["keyword"] = {KhaosParseTree}

		-- Contrastingly, numeric indexes signify actions
		[1] = {
			-- If you did not explicitly set a key the Id of the option will work. 
			key = "SomeKey"; 
			
			-- This will use a keyword map to determine how to modify that key
			stringMap = {
				-- If a custom keyword comes next, it will use the values
				-- to determine how to change the key
				["on"] = { checked=true; slider=5; color=RED_FONT_COLOR; }
				["off"] = { checked=false; slider=1; color=NORMAL_FONT_COLOR; }
			};

			-- You can also directly modify that key using special codes
			valueMap = {
				checked=true;
				slider="%1d";

				-- The %1 means parse the first word after "/khaoscomm keyword"; 
				-- So /khaoscomm 123 would say take "123" and parse it

				-- %1  - keep it as a string
				-- %1d - convert it to a number
				-- %1b - convert it to a boolean (true/false)

				-- Theoretically, I could support %##, but I won't until there's
				-- a need for it. So please keep modifiers down to 9 or less.
			};
		}
		-- Finally, you can specify a custom action to be performed
		[2] = {
			callback = function(msg) 
				Sea.io.print("You typed /khaoscomm "..msg);
			end;
		};
	};
	
	The Khaos slash command lets you setup a simple parse tree which will read the 
	input and reconfigure keys within the current set based on the words entered.

	If the key of the parseTree is a word, it will branch into that tree:

	Example: 
		{
			commands = {"/demo"};
			parseTree = {
				foo = {
					[1] = {
						key = "DemoKey1";
						stringMap = {
							blue = { checked=true; }
							red = { checked=false; }
							custom = { checked=true; }
						}
					};
					[2] = {
						key = "DemoKey2";
						stringMap = {
							blue = { slider=1; }
							red = { slider=2; }
							custom = { slider="%1d"; }
						}
					};
				};
				bar = {
					[1] = {
						key = "DemoKey1";
						valueMap = {
							checked = true;
						};
					};
					[2] = {
						key = "DemoKey2";
						valueMap = {
							slider = "%1d";
						};
					};
				};
				baz = {
					callback = function(msg) 
						Sea.io.print(msg);
					end;
				}
			};
		}
		
	Result:
		/kt foo blue
		
		Would set DemoKey1 to checked and DemoKey2's slider to 1. 
		
		/kt foo custom 5
		
		Would set DemoKey1 to checked and DemoKey2's slider to 5. 

		/kt bar 1

		Would do the same thing. DemoKey1 would always be checked with bar, 
		but the %1d would convert it to a number. 

		/kt baz blue 43 hut!

		Would print out "blue 43 hut!". 
		
	
--------------------------------------------------

	KhaosOption =  {
		id = "ModOptionId";
		key = "SharedDataKey";
		value = 5;
		text = "Some Uber Feature";
		helptext = "Some long description of what this option does";
		callback = function(state) Sea.io.printComma(state.checked, state.value); end;
		feedback = function(state) 
			if ( state.checked ) then 
				return "Uber feature is enabled at "..state.slider.." percent.";
			else
				return "Uber feature is disabled.";
			end
		end;
		check = boolean; 
		radio = boolean;
		type = K_TEXT|K_BUTTON|K_SLIDER|K_PULLDOWN|K_EDITBOX|K_HEADER;
		setup = {
			-- radio
			selectedColor = {r=0,g=1,b=0};
			disabledColor = {r=1,g=0,b=0};
			
			-- If slider
			min = 0;
			max = 1;
			step = .1;
			sliderDisplayFunc = function ( value ) return (math.floor(slidervalue*100)/100).."%"; end;

			-- If pulldown
			options = {
				["Foo"] = 1,
				["Bar"] = 2,
				["Baz"] = "mew"
			};
			multiSelect=true; 

			-- If editbox
			callOn = { 
				-- Call when the user types a space
				"space", 
				-- Call when the box is selected
				"focus", 
				-- Call when the user hits escape
				"escape", 
				-- Call when the user hits tab
				"tab", 
				-- Call when the user changes the text
				"change", 
				-- Call when the user hits enter or selects something else
				"set", 
				-- Call on all of these things
				"all" 
			};

			-- If colorpicker
			hasOpacity = true; -- If you want to show an opacity slider			
			
		};
		default = {
			checked = true;
			slider = .5;

			-- For color picker only
			color = { r=1.0, g=.5, b=.24, opacity=1 };
		};
		disabled = {
			checked = false;
			slider = .0;
			
			color = { r=1.0, g=1.0, b=1.0, opacity=.5 };
		};
		dependencies = {
			["key"] = { value=3; match=true; checked=false }; 
			["key2"] = { value=3; match=false; }; 
		};
		slashCommands = {
			toggle = { "/togglemyoption" }; 
			select = { "/selectmyoption" }; 
			setValue = { "/setmyoptionvalue" };
			custom = { "/myoption" };
		}
	}

	id - unique value for this specific option. used to modify the option later
	key - string id for the key which will hold data related to this option		
	value - value of key.value when the check/radio is clicked
	difficulty - allow you to hide advanced configurations from simple users
	
	text - 	string - short text displayed 
	helptext - long description of what this option will do when set
	callback - function called when the option is modified. 
		(state, keypressed)
		state - the new state due to user input
		keypressed - editbox only, tells you the key that triggered the callback
		
	feedback - function that is called whenever the state changes
		it should return a string that describes the current state
		of the option. This will be used for the newbie interface. 
		Same arguments as callback.

	check - true - show the check 
			If radio is true, check = true means the radio can be unchecked
		false - dont show the check

	radio - true - will be unchecked if the folder[key]'s value doesnt match your value
		false - will only uncheck if clicked.

	type - the main type of this node
		K_TEXT - text only
		K_BUTTON - push to call callback with state
		K_SLIDER - a variable slider which callback on changes
		K_EDITBOX - an edit box which does callback on the specified events
		K_PULLDOWN - a menu which callback when you select options
		K_HEADER - a string separator which displays a text bit

	setup - table which varies depending on type
		K_TEXT - nothing
		K_BUTTON - 
			buttonText - text for the button
		K_SLIDER -
			sliderMin - min value of slider
			sliderMax - max value of slider
			sliderLow - low text string
			sliderHigh - high text string
			sliderStep - increment between for slider
			sliderText - text over the slider
			sliderDisplayFunc - function used to generate slider text
		K_EDITBOX - 
			callOn - list of events that trigger callbacks
				(tab, space, enter, escape)
				
		K_PULLDOWN - 
			options - table of key-value pairs the user can pick from
			multiSelect - if true, multiple values can be selected
		K_COLORPICKER
			hasOpacity - true if it has an opacity slider
		K_HEADER - nothing
			
	
	default - the default state of the option's key
		value - value of the key
		checked - true if checked, false if not
		slider - value of the slider
		options - table containing the options checked
		
	disabled - the state of the key when the config set is disabled
		(same properties as default)

	dependencies - key based dependencies which will be checked. If any are false, the Option is disabled
		value - the value the key will be tested against
		checked - the checked state the key will be tested against
		match - true - the dependency will be true if key's value equals dependency value
			false - the dependency will be true if the key's value is not equal to the dependency's value

	slashCommands - a list of slash commands which will update the activeConfiguration and call the callback
		toggle - for checkboxes, toggles the option on and off
		select - for radio, selects that option as the active option
		setValue - for slider types, set the value according to the tonumber() of the string passed in
		custom - for advanced addon authors, creates a function whose args will be
			(msg, callback, state)
			msg - the text message
			callback - a call which takes a modified state and updates both the activeConfig and calls the correct function
			state - current state of the configuration

			* Please note, you can also use the getOptionCallback method to obtain this callback function for your own use*
			
		
--------------------------------------------------

	ConfigurationLoadNotice = {	
		id = "SomeID";
		onConfigurationChange = function () Sea.io.print("The configuration has changed, update gui!"); end;
		description = "A simple notification system for modders who want to know when configs change.";
	};
]]--
