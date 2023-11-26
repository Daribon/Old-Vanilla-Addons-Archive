function ThottbotReplace_ReplaceIt()
	local ThottbotReplaceTlocCommands = {"/tloc", "/thottbotloc"};
	local ThottbotReplaceTlocInfo = "display current Thottbot location coordinates";
	local ThottbotReplaceTlocFunction = function(msg)
		if (ThottbotReplace_IsActive and msg == "") then
			ThottbotReplace_IsActive = false;
			ThottbotReplace_ThottbotText:Hide();
			if (ThottbotLocationFrame) then ThottbotLocationFrame:Hide();	end
		else
			ThottbotReplace_IsActive = true;
			if (ThottbotReplace_ThottbotText) then 
				ThottbotReplace_ThottbotText:Show(); 
			else -- just in case thottbot isn't loaded (the user delete the folder or something like this)
				print1("Thottbot isn't loaded, this is a Thottbot function. Use '/mntloc xx,yy' to show a location on the map.");
				ThottbotReplace_IsActive = false;
				return;
			end
			ThottbotReplace_UpdateMinimapText();
			print1("Current Thottbot location is under the minimap.");
			if (msg ~= "") then
				local i,j,x,y = string.find(msg,"(%d+),(%d+)");
				if (x and y) then
					MapNotes_tloc_xPos = (x + 0.5) / 100;
					MapNotes_tloc_yPos = (y + 0.5) / 100;
					print1("Target Thottbot location is on the zone map.");
				else
					print1("Usage: /tloc x,y");
				end 
			else
				MapNotes_tloc_xPos = nil;
				MapNotes_tloc_yPos = nil;
				print1("Note: /tloc x,y will show coordinates on the map.");
				print1("Note2: /goto x,y will try to take you there! Use at your own risk. No refunds.");
			end 
		end 
	end 
	if (not ThottbotText) then Cosmos_RegisterChatCommand("TLOC", ThottbotReplaceTlocCommands, ThottbotReplaceTlocFunction, ThottbotReplaceTlocInfo ); end

	function ThottbotReplace_UpdateMinimapText()
		if (ThottbotReplace_IsActive) then
			local x,y = GetPlayerMapPosition("player");
			x = round(x*100);
			y = round(y*100);
			ThottbotReplace_ThottbotText:SetText(format("%2d,%2d",x,y));
			Cosmos_ScheduleByName("Tloc",0.1,ThottbotReplace_UpdateMinimapText);
		end
	end

	function round(x)
		if (x - math.floor(x) > 0.5) then
			x = x + 0.5;
		end
		return math.floor(x);
	end
end