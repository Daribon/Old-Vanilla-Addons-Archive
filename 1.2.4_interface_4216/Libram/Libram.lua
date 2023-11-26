--[[
--	Libram
--	 	Knowledge is best shared
--	
--	By: Alexander Brazie
--	Special Thanks: Anders Kronquist
--	
--	This Add-On allows you to register to specific events
--	which affect the quest log. 
--	
--	$Id: Libram.lua 1000 2005-03-11 02:33:21Z AlexYoshi $
--	$Rev: 1000 $
--	$LastChangedBy: AlexYoshi $
--	$Date: 2005-03-10 21:33:21 -0500 (Thu, 10 Mar 2005) $
--]]

-- Constants
LIBRAM_QUEST_ADD = "ADD"; -- Acquired
LIBRAM_QUEST_REMOVE = "REMOVE"; -- Abandoned
LIBRAM_QUEST_CHANGED = "CHANGED"; -- Id is a different quest
LIBRAM_QUEST_COMPLETED = "COMPLETED"; -- Quest completed
LIBRAM_QUEST_FAILED = "FAILED"; -- Quest failed
LIBRAM_QUEST_INIT = "INIT"; -- Initialized
LIBRAM_QUEST_TIMER = "TIMER"; -- Quest timer updated
LIBRAM_QUEST_UPDATE = "UPDATE"; -- Quest updated

-- Arcanan refresh rate
LIBRAM_ARCANA_REFRESH = 10; -- QuestLogUpdates
LIBRAM_ARCANA_EXPIRATION = 180; -- Seconds

-- Debug
LIBRAM_DEBUG = false;
LM_DEBUG = "LIBRAM_DEBUG";
LIBRAM_DEBUG_DETAILED = false;
LM_DEBUG_D = "LIBRAM_DEBUG_DETAILED";
LIBRAM_DEBUG_TABLES = false;
LM_DEBUG_T = "LIBRAM_DEBUG_TABLES";

Libram = {
	-- Online switch
	online = true;
	
	--[[ 
	--	registerScholar ( {scholar} [, {scholar} ] ) 
	--		Registers a scholar with the specifed id
	--		who will be notified when the quest log
	--		updates or changes. 
	--
	--	args:
	--		scholar - table
	--		{
	--			id - unique ID for the scholar
	--			callback - callback function 
	--				callback(action, questInfo, updateInfo)
	--				
	--				action - string - the action which has happened:
	--					ADD|REMOVE|CHANGED|COMPLETED|FAILED|UPDATE|TIMER|INIT
	--					
	--				questInfo - table
	--					title - quest title
	--					level - quest level
	--					completed - boolean
	--					id - quest id
	--					
	--				updateInfo - table
	--					text - updated text
	--					done - amount done
	--					total - total needed
	--			description - description string
	--			
	--		}
	--
	--	returns: 
	--		true - scholar enrolled successfully
	--		false - scholar was not valid 
	--]]
	registerScholar = function (...)
		local success = true;
		for i=1,table.getn(arg) do
			if ( Libram.validateScholar(arg[i] ) ) then 
				LibramData.scholars[arg[i].id] = arg[i];
			else
				success = false;
			end
		end
		return success;
	end;

	--[[
	--	validateScholar({scholar})
	--		Ensures a scholar can afford to pay the bills.
	--
	--	args:	
	--		see registerScholar
	--
	--	returns:
	--		true - valid scholar
	--		false - invalid scholar
	--]]
	validateScholar = function (scholar)
		if ( not scholar ) then
			Sea.io.error("Scholar is nil: ", this:GetName() );
			return false;
		end
		if ( not scholar.id ) then 
			Sea.io.error("Scholar has no id! Sent by ",this:GetName());
			return false;
		end
		if ( type(scholar.id) ~= "string" ) then 
			Sea.io.error("Scholar ID is not a string: ",scholar.id, " from ", this:GetName());
			return false;
		end
		if ( LibramData.scholars[scholar.id] ) then 
			Sea.io.error("Scholar ID is already in use: ",scholar.id, " from ", this:GetName());
			return false;
		end

		if ( type(scholar.callback) ~= "function" ) then 
			Sea.io.error("Scholar callback is not a function: ",scholar.id, " from ", this:GetName());
			return false;
		end
		
		return true;
	end;

	--[[
	--	unregisterScholar(id)
	--		unregisters the scholar with the specified id
	--
	--	args
	--		id - string id
	--
	--]]
	unregisterScholar = function(id)
		LibramData.scholars[id] = nil;
	end;

	--[[
	--	requestHistory()
	--		Returns a table to the current history.
	--		Don't change it... unless you want to break things.
	--
	--	returns:
	--		table - the current quest log history
	--		nil - no history yet
	--
	--]]
	requestHistory = function () 
		return LibramData.history;
	end;

	--[[
	--	requestRecord(questID)
	--		Returns a table containing all of the 
	--		information regarding a particular quest. 
	--
	--	args:
	--		questID - questID matching the quest id
	--			given in requestHistory()
	--
	--	returns:
	--		table - the record of that quest
	--		nil - record unavailable
	--		
	--]]
	requestRecord = function ( questID )
		for zone, questList in LibramData.history do 
			for k,quest in questList do 
				if ( type(quest) == "table" ) then 
					if ( quest.id == questID ) then
						return LibramData.getTome(quest.title,quest.level, quest.id);
					end
				else
					Sea.io.dprint(LM_DEBUG, "The Researchers discover someone has tampered with the records!");
				end
			end
		end		
	end;
};

LibramData = {
	-- Registrants
	scholars = {};

	-- Old Log
	history = nil;

	-- Old Quest Data
	arcana = {};

	-- Arcana timer 
	arcanaCount = 0;

	-- Updates the history
	updateHistory = function()
		local discoveries = {};
		local recent = Sea.wow.questLog.getPlayerQuestTree();
	
		if ( not LibramData.history ) then 
			table.insert ( discoveries, {type=LIBRAM_QUEST_INIT} );
			LibramData.history = recent;
		elseif ( recent ) then 
			-- Perform the evil ritual of quadruple loops
			for zone,questList in recent do 
				-- compare with old zone
				if ( LibramData.history[zone] ) then 
					for i=1,table.getn(questList) do 
						local quest = questList[i];
						local found = false;
						for k2,oldQuest in LibramData.history[zone] do
							if ( type (oldQuest) == "table" ) then 
								-- Matched!
								if ( quest.title == oldQuest.title and quest.level == oldQuest.level ) then 
									-- Has the quest ID changed?
									if ( quest.id ~= oldQuest.id ) then 
										Sea.io.dprint(LM_DEBUG, "Libram: The Researchers decree: Quest Changed! ", quest.title );
										table.insert(discoveries, { type = LIBRAM_QUEST_CHANGED; questInfo = {title=quest.title;level=quest.level;id=quest.id;}; updateInfo={newid=quest.id;oldid=oldQuest.id} } );
									end
										
									-- Quest has been compelted
									if ( quest.complete and not oldQuest.complete ) then 
										Sea.io.dprint(LM_DEBUG, "Libram: The Researchers decree: Quest Completed! ", quest.title );
										table.insert(discoveries, { type = LIBRAM_QUEST_COMPLETED; questInfo = {title=quest.title;level=quest.level;id=quest.id} } );
									end
	
									-- Remove from the old list, we've handled it
									LibramData.history[zone][k2] = nil;
									found = true;
								end
							end
						end

						-- Was not found in the history books, report its discovery
						if ( not found ) then 
							Sea.io.dprint(LM_DEBUG, "Libram: The Researchers decree: Quest Added! ", quest.title );						
							table.insert(discoveries, { type = LIBRAM_QUEST_ADD; questInfo = {title=quest.title;level=quest.level;id=quest.id}; updateInfo={zone=zone} } );
						end
					end

					-- If there's anything no longer found, it aws lost
					for k2, oldQuest in LibramData.history[zone] do 
						if ( type (oldQuest) == "table" ) then
							Sea.io.dprint(LM_DEBUG, "Libram: The Researchers decree: Quest Removed! ", oldQuest.title );
							table.insert(discoveries, { type = LIBRAM_QUEST_REMOVE; questInfo = {title=oldQuest.title;level=oldQuest.level;id=oldQuest.id}; updateInfo={zone=zone}; } );
						end
					end
				else
					-- A new zone means new quests
					for k,quest in questList do 
						Sea.io.dprint(LM_DEBUG, "Libram: The Researchers decree: Quest Added! ", quest.title );
						table.insert(discoveries, { type = LIBRAM_QUEST_ADD; questInfo = {title=quest.title;level=quest.level;id=quest.id}; updateInfo={zone=zone};} );
					end
				end
			end

			-- Store the history
			LibramData.history = recent;
		end

		-- Debug!
		if ( getglobal(LM_DEBUG_T) ) then 
			Sea.io.printTable(discoveries);
		end

		-- Let the world know
		LibramData.notifyScholars(discoveries);
	end;
	
	-- Updates the arcana (cache)
	updateArcana = function()
		local discoveries = {};

		if ( not Sea.wow.questLog.protectQuestLog() ) then 
			return false; 
		end
	
		-- Expand everything
		ExpandQuestHeader(0);

		local total = GetNumQuestLogEntries();
		Sea.io.dprint(LM_DEBUG, "Libram: Researchers are accessing ", total, " Arcana.");

		for i=1,total do 
			local title, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);

			if ( not isHeader ) then 
				if ( LibramData.arcana[title] ) then
					Sea.io.dprint(LM_DEBUG_D, "Researchers are investigating ", title, " ", level);
					-- If we have this tome check for changes
					if ( LibramData.arcana[title][level] ) then
						Sea.wow.questLog.unprotectQuestLog();
						local research = Sea.wow.questLog.getPlayerQuestData(i);
						Sea.wow.questLog.protectQuestLog();

						-- If we can't do research, just return.
						if ( not research ) then return; end

						Sea.io.dprint(LM_DEBUG_D, "Researchers confirm the existence of ", title, " ", level);
						
						-- Discover failure
						if ( research.failed and not LibramData.arcana[title][level].failed ) then 
							Sea.io.dprint(LM_DEBUG, "Libram: The Researchers decree: Quest Failed! ", title );
							table.insert(discoveries, { type = LIBRAM_QUEST_FAILED; questInfo = research;  } );							
						end

						-- Discover changing timer
						if ( research.timer ~= LibramData.arcana[title][level].timer ) then 
							Sea.io.dprint(LM_DEBUG, "Libram: The Researchers decree: Quest is Timed! ", title );
							table.insert(discoveries, { type = LIBRAM_QUEST_TIMER; questInfo = research;  } );							
						end

						-- Discover objective updates
						for k,v in research.objectives do 
							local updated = false;
							
							if ( getglobal(LM_DEBUG_T) ) then 
								Sea.io.printTable(v.info);
								Sea.io.printTable(LibramData.arcana[title][level].objectives[k].info);
							end

							if ( v.finished and not LibramData.arcana[title][level].objectives[k].finished ) then 
								updated = true;
							elseif ( v.info ) then 
								if ( not  LibramData.arcana[title][level].objectives ) then 
									updated = true;
								elseif ( not  LibramData.arcana[title][level].objectives[k] ) then 
									updated = true;									
								elseif ( not  LibramData.arcana[title][level].objectives[k].info ) then 
									updated = true;									
								elseif ( v.info.text ~= LibramData.arcana[title][level].objectives[k].info.text ) then 
									updated = true;
								elseif ( v.info.done ~= LibramData.arcana[title][level].objectives[k].info.done ) then 
									updated = true;
								end								

								if ( v.info.text == nil or v.info.text == "" ) then 
									Chronos.scheduleByName("LibramArcanaUpdate", 3, LibramData.updateArcana );
								end
							end

							if ( updated ) then 
								Sea.io.dprint(LM_DEBUG, "Libram: The Researchers decree: Quest Updated! ", title );
								table.insert(discoveries, { type = LIBRAM_QUEST_UPDATE; questInfo = research; updateInfo=v; } );
							end								
						end

						LibramData.arcana[title][level] = research;
						LibramData.arcana[title].time = GetTime();
					else
						-- Request the tome
						LibramData.getTome(title, level, i);
					end				
				else
					Sea.io.dprint( LM_DEBUG, "Libram: Researchers find ", title, " for the first time." );
					-- Request the tome
					LibramData.getTome(title, level, i);
				end
			end
		end
		
		-- Debug!
		if ( getglobal(LM_DEBUG_T) ) then 
			Sea.io.printTable(discoveries);
		end

		-- Let the world know
		LibramData.notifyScholars(discoveries);	

		-- Unprotect
		Sea.wow.questLog.unprotectQuestLog();	
		return nil;		
	end;

	-- Notifies the scholars of discoveries
	notifyScholars = function ( discoveries )
		if ( table.getn(discoveries) > 0 ) then 
			Sea.io.dprint(LM_DEBUG, "Libram: The Researchers are notifying the Scholars of ",table.getn(discoveries), " discoveries!");
		
			for k,discovery in discoveries do 
				for k2,scholar in LibramData.scholars do 
					scholar.callback(discovery.type, discovery.questInfo, discovery.updateInfo );
				end
			end
		end
	end;

	-- Gets a quest tome from the cache
	getTome = function ( title, level, id ) 
		if ( not LibramData.arcana ) then 
			LibramData.arcana = {};
		end
		if ( not LibramData.arcana[title] ) then 
			LibramData.arcana[title] = {};
			LibramData.arcana[title].time = 0;
		end
		
		-- Acquire non-existent tomes or update old ones
		if ( not LibramData.arcana[title][level] or
			LibramData.arcana[title].time + LIBRAM_ARCANA_EXPIRATION < GetTime() ) then
			local research = Sea.wow.questLog.getPlayerQuestData(id);
			if ( research ) then 
				Sea.io.dprint(LM_DEBUG, "Libram: Archivists are keeping ", title, " for a later time. ");
				LibramData.arcana[title][level] = research;
				LibramData.arcana[title].time = GetTime();
			end
		
		end

		-- Copy the time for publication
		if ( LibramData.arcana[title][level] ) then 
			LibramData.arcana[title][level].time = LibramData.arcana[title].time;
		end
		
		return LibramData.arcana[title][level];	
	end;
};

--[[ OnLoad ]]--
function Libram_OnLoad()
	this:RegisterEvent("QUEST_LOG_UPDATE");
	this:RegisterEvent("UI_INFO_MESSAGE");
	
	-- Initialize
	Chronos.afterInit(function() Libram.online=false; LibramData.updateHistory(); Libram.online=true; end);
	Chronos.afterInit(function() Libram.online=false; LibramData.updateArcana(); Libram.online=true; end);
end

--[[ Handles Full Refreshes ]]--
function Libram_OnEvent(event) 
	if ( not Libram.online ) then 
		return;
	end

	-- Shut the doors while we do research
	Libram.online = false;
	
	-- Update the history books every time
	if ( event == "QUEST_LOG_UPDATE" ) then 
		LibramData.updateHistory();
		LibramData.arcanaCount = LibramData.arcanaCount + 1;
	end

	-- Update the arcana every 10 updates
	if ( LibramData.arcanaCount > LIBRAM_ARCANA_REFRESH ) then 
		LibramData.updateArcana();
		LibramData.arcanaCount = 0;
	end
	-- Mark the arcana for a full update next QUEST_LOG_UPDATE
	if ( event == "UI_INFO_MESSAGE" ) then
		LibramData.arcanaCount = LIBRAM_ARCANA_REFRESH + 1;
	end		

	-- Open the doors when research is completed.
	Libram.online = true;
end
