function ReagentData_LoadQuestItems()
     ReagentData['quest'] = {};
     ReagentData['quest']['Zul\'Gurub'] = {};

     -- Raw quest items for Zul'Gurub
     ReagentData['quest']['Zul\'Gurub']['item'] = {
	  ['coin'] = {
	       ['bloodscalp'] = "Bloodscalp Coin",
	       ['gurubashi'] = "Gurubashi Coin",
	       ['hakkari'] = "Hakkari Coin",
	       ['razzashi'] = "Razzashi Coin",
	       ['sandfury'] = "Sandfury Coin",
	       ['skullsplitter'] = "Skullsplitter",
	       ['vilebranch'] = "Vilebranch Coin",
	       ['witherbark'] = "Witherbark Coin",
	       ['zulian'] = "Zulian Coin",
	  },
	  ['bijou'] = {
	       ['blue'] = "Blue Hakkari Bijou",
	       ['bronze'] = "Bronze Hakkari Bijou",
	       ['gold'] = "Gold Hakkari Bijou",
	       ['green'] = "Green Hakkari Bijou",
	       ['orange'] = "Orange Hakkari Bijou",
	       ['purple'] = "Purple Hakkari Bijou",
	       ['red'] = "Red Hakkari Bijou",
	       ['silver'] = "Silver Hakkari Bijou",
	       ['yellow'] = "Yellow Hakkari Bijou",
	  },
	  ['primal'] = {
	       ['aegis'] = "Primal Hakkari Aegis",
	       ['armsplint'] = "Primal Hakkari Armsplint",
	       ['bindings'] = "Primal Hakkari Bindings",
	       ['girdle'] = "Primal Hakkari Girdle",
	       ['kossack'] = "Primal Hakkari Kossack",
	       ['sash'] = "Primal Hakkari Sash",
	       ['shawl'] = "Primal Hakkari Shawl",
	       ['stanchion'] = "Primal Hakkari Stanchion",
	       ['tabard'] = "Primal Hakkari Tabard",
	  },
     };

     -- Now the class specific uses
     ReagentData['quest']['Zul\'Gurub']['use'] = {
	  ['Druid'] = {
	       ['Bracer'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['hakkari']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['vilebranch']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['red']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['stanchion']] = 1,
	       },
	       ['Belt'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['razzashi']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['sandfury']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['green']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['sash']] = 1,
	       },
	       ['Chest'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['gurubashi']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['zulian']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['bronze']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['tabard']] = 1,
	       },
	  },
	  ['Hunter'] = {
	       ['Bracer'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['sandfury']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['skullsplitter']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['yellow']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['bindings']] = 1,
	       },
	       ['Belt'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['hakkari']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['razzashi']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['green']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['shawl']] = 1,
	       },
	       ['Shoulder'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['gurubashi']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['zulian']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['silver']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['aegis']] = 1,
	       },
	  },
	  ['Mage'] = {
	       ['Bracer'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['vilebranch']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['witherbark']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['blue']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['bindings']] = 1,
	       },
	       ['Shoulder'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['gurubashi']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['razzashi']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['orange']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['shawl']] = 1,
	       },
	       ['Chest'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['sandfury']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['zulian']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['silver']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['kossack']] = 1,
	       },
	  },
	  ['Paladin'] = {
	       ['Bracer'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['witherbark']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['zulian']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['red']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['bindings']] = 1,
	       },
	       ['Belt'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['bloodscalp']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['skullsplitter']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['purple']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['shawl']] = 1,
	       },
	       ['Chest'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['sandfury']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['vilebranch']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['gold']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['tabard']] = 1,
	       },
	  },
	  ['Priest'] = {
	       ['Bracer'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['bloodscalp']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['sandfury']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['yellow']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['stanchion']] = 1,
	       },
	       ['Belt'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['hakkari']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['zulian']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['orange']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['sash']] = 1,
	       },
	       ['Shoulder'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['razzashi']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['witherbark']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['bronze']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['aegis']] = 1,
	       },
	  },
	  ['Rogue'] = {
	       ['Bracer'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['bloodscalp']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['vilebranch']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['blue']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['armsplint']] = 1,
	       },
	       ['Shoulder'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['razzashi']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['zulian']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['purple']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['girdle']] = 1,
	       },
	       ['Chest'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['hakkari']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['skullsplitter']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['gold']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['aegis']] = 1,
	       },
	  },
	  ['Shaman'] = {
	       ['Bracer'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['bloodscalp']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['razzashi']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['blue']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['armsplint']] = 1,
	       },
	       ['Belt'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['gurubashi']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['skullsplitter']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['purple']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['girdle']] = 1,
	       },
	       ['Chest'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['hakkari']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['witherbark']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['gold']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['tabard']] = 1,
	       },
	  },
	  ['Warlock'] = {
	       ['Bracer'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['gurubashi']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['vilebranch']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['red']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['stanchion']] = 1,
	       },
	       ['Shoulder'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['hakkari']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['witherbark']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['orange']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['sash']] = 1,
	       },
	       ['Chest'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['bloodscalp']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['skullsplitter']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['silver']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['kossack']] = 1,
	       },
	  },
	  ['Warrior'] = {
	       ['Bracer'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['gurubashi']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['witherbark']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['yellow']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['armsplint']] = 1,
	       },
	       ['Belt'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['skullsplitter']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['vilebranch']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['green']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['girdle']] = 1,
	       },
	       ['Chest'] = {
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['bloodscalp']] = 5,
		    [ReagentData['quest']['Zul\'Gurub']['item']['coin']['sandfury']] = 5,		
		    [ReagentData['quest']['Zul\'Gurub']['item']['bijou']['bronze']] = 2,
		    [ReagentData['quest']['Zul\'Gurub']['item']['primal']['kossack']] = 1,
	       },
	  },
     };

     -- ReagentData_IsQuestItem(item, [zone])
     --
     -- This function takes an item and returns the zone in which the item is used (false if none).
     -- If a zone is specified as well as the item name, the function will return true or false
     -- depending on whether the item is used in quests in that zone or not

     function ReagentData_IsQuestItem(item, zone)
	  if (item == nil or ReagentData['quest'] == nil) then
	       return false;
	  end

	  for checkzone, outerarrays in ReagentData['quest'] do
	       if (zone == nil or zone == ""  or checkzone == zone) then
		    for itemclass, innerarrays in outerarrays['item'] do
			 for trash, checkitem in innerarrays do
			      if (checkitem == item) then
				   return checkzone;
			      end
			 end
		    end
	       end
	  end

	  return false;
     end

     -- ReagentData_QuestUsage(item, zone)
     --
     -- This function takes an item and a zone.  It then returns some information about the usage of that item
     -- in the zone.  Because there's no way to predict how this could be used in the future (Blizzard could
     -- do anything with new quests), the data returned will depend completely on the zone.  Fun, huh?  False will
     -- always be returned on non matches.
     --
     -- Zul'Gurub
     -- ---------
     -- For Zul'Gurub, the function will return an array.  Each element in this array will be a two element array
     -- like {class, armor part}.  This will allow you to determine which classes use which items for which pieces
     -- of armor.  For example, calling ReagentData_QuestUsage("Primal Hakkari Aegis", "Zul'Gurub") will return:
     -- {{"Hunter", "Shoulder"}, {"Priest", "Shoulder"}, {"Rogue", "Chest"}}.  It is up to the individual mod authors
     -- to determine how best to use this information.

     function ReagentData_QuestUsage(item, zone)
	  if (item == nil or ReagentData['quest'] == nil or not ReagentData_IsQuestItem(item, zone)) then
	       return false;
	  end
	
	  local returnArray = {};

	  if (zone == "Zul'Gurub") then
	       for class, array in ReagentData['quest']['Zul\'Gurub']['use'] do
		    for armor, subarray in array do
			 for piece, count in subarray do
			      if (piece == item) then
				   tinsert(returnArray, {[class] = armor});
			      end
			 end
		    end
	       end
	  end

	  return returnArray;
     end
end