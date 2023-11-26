-- //////////////////////////////////////////////////////////////////////////////////////
-- //
-- // BuffWatch
-- // 	by Tyrrael aka Paul2200
-- //
-- //
-- //
-- //
-- //////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////
-- //
-- //				Variables
-- //
-- //////////////////////////////////////////////////////////////////////////////////////

	BINDING_HEADER_BUFFWATCHHEADER = "BuffWatch! by Tyrrael"
	BuffWatchConfig = { runCount, alpha, rightMouseSpell, show_on_startup }

	local UNIT_IDs = {"player", "pet", "party1", "", "party2", "", "party3", "", "party4", ""}

	local lastspellcast
	local RMouseSpellID

-- //////////////////////////////////////////////////////////////////////////////////////
-- //
-- //
-- //				Standard Functions
-- //
-- //
-- //////////////////////////////////////////////////////////////////////////////////////

	function BW_OnLoad()

 		this:RegisterEvent("PARTY_MEMBERS_CHANGED")
		this:RegisterEvent("PLAYER_ENTERING_WORLD")
		this:RegisterEvent("PLAYER_REGEN_ENABLED")
 		this:RegisterEvent("RAID_ROSTER_UPDATE")
		this:RegisterEvent("SPELLCAST_START")
		this:RegisterEvent("SPELLCAST_STOP")
		this:RegisterEvent("UNIT_AURA")
		this:RegisterEvent("UNIT_NAME_UPDATE")
		this:RegisterEvent("VARIABLES_LOADED")
		this:RegisterEvent("UI_ERROR_MESSAGE")

		SlashCmdList["BUFFWATCH"] = BW_SlashHandler
		SLASH_BUFFWATCH1 = "/buffwatch"
		SLASH_BUFFWATCH2 = "/bw"

	end
	-----------------------------------------------------------------------
	function BW_OnEvent()

		if event == "VARIABLES_LOADED" then

			-- BW_Print( "Tyrrael's BuffWatch loaded. Please type /buffwatch or /bw for Usage (window must be visible)", 0.2, 0.9, 0.9 )
			getglobal("BuffWatchFrameHeaderText"):SetText("BuffWatch")
			getglobal("BuffWatchFrameHeaderText"):SetTextColor(0.2, 0.9, 0.9)
			BuffWatchBackdropFrame:SetBackdropBorderColor( 0,0,0 )

			if BuffWatchConfig.runCount == nil then
				BuffWatchConfig.runCount = 1
			end

			if BuffWatchConfig.runCount == 1 then
				BW_Print( "First Run Detected: Bind a keyboard button to show/hide the BuffWatch Frame", 0.2, 0.9, 0.9 )
				BW_Print( "Or type \"/buffwatch toggle\", then \"/buffwatch\" for usage", 0.2, 0.9, 0.9 )
				BuffWatchConfig.runCount = BuffWatchConfig.runCount + 1
			else
				BuffWatchConfig.runCount = BuffWatchConfig.runCount + 1
			end

			if BuffWatchConfig.alpha == nil then
				BuffWatchConfig.alpha = 0.5
			end

			BuffWatchBackdropFrame:SetAlpha( BuffWatchConfig.alpha )

			if BuffWatchConfig.rightMouseSpell then
				RMouseSpellID = BuffWatchConfig.rightMouseSpell
			end

			if BuffWatchConfig.show_on_startup == nil then
				BuffWatchConfig.show_on_startup = "yes"
				BuffWatchFrame:Show()
			elseif BuffWatchConfig.show_on_startup == "yes" then
				BuffWatchFrame:Show()
			elseif BuffWatchConfig.show_on_startup == "no" then
				BuffWatchFrame:Hide()
			end

		end

		if event == "PLAYER_ENTERING_WORLD" then

			BW_Set_UNIT_IDs()
			BW_GetAllBuffs()

		end

		if event == "PLAYER_REGEN_ENABLED" then

			BW_Set_UNIT_IDs()
			BW_GetAllBuffs()

			BW_UpdateBuffStatus()
			--BW_UpdateBuffStatus_Pets()
			BW_ResizeWindow()

		end

		if event == "SPELLCAST_START" then

			lastspellcast = arg1

		end

		if event == "UNIT_AURA" then

			for i=1,table.getn(UNIT_IDs) do
				if UnitName(arg1) == getglobal("BW_Player" .. i .. "_NameText"):GetText() then
					BW_Player_GetBuffs(i)
					break
				end
			end

		end

		if event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" then

			BW_Set_UNIT_IDs()
			BW_GetAllBuffs()

			BW_UpdateBuffStatus()
			--BW_UpdateBuffStatus_Pets()
			BW_ResizeWindow()

		end

	end

-- //////////////////////////////////////////////////////////////////////////////////////
-- //
-- //
-- //				Main Functions
-- //
-- //
-- //////////////////////////////////////////////////////////////////////////////////////

	function BW_GetAllBuffs()

		local firstvisibleplayer = true
		local previousvisibleplayer

		for i=1,table.getn(UNIT_IDs) do

			local curr_playerframe		= getglobal("BW_Player" .. i)
			local curr_name_button		= getglobal("BW_Player" .. i .. "_Name")
			local curr_name_fontstring	= getglobal("BW_Player" .. i .. "_NameText")

			-----
			local unitname

			if math.mod(i,2) == 1 then
				unitname = UnitName(UNIT_IDs[i])
			--[[elseif i <= 10 then -- only party pets -- party pets commented out 04-19
				if UnitName(UNIT_IDs[i-1]) then
					if UnitClass(UNIT_IDs[i-1]) == "Hunter" or UnitClass(UNIT_IDs[i-1]) == "Warlock" then
						TargetByName(UnitName(UNIT_IDs[i-1]))
						local personname = UnitName("target")
						if personname then
							TargetUnitsPet("target")
							local petname = UnitName("target")

							if petname and personname and petname ~= personname then
								unitname = UnitName("target")
							end
						end
					end
				end]]
			end
			-----

			if unitname == nil then

				curr_playerframe		:Hide()
				curr_name_button		:Hide()
				curr_name_fontstring	:Hide()
				curr_name_fontstring	:SetText( nil )

			else

				curr_playerframe		:Show()
				curr_name_button		:Show()
				curr_name_fontstring	:Show()
				curr_name_fontstring	:SetText( unitname )
				curr_name_fontstring	:SetTextColor(1, 1, 1);

				if firstvisibleplayer then

					curr_name_button		:ClearAllPoints()
					curr_name_button		:SetPoint("TOPLEFT","BuffWatchBackdropFrame","TOPLEFT",15,-15)
					previousvisibleplayer	= i
					firstvisibleplayer		= false

				else

					curr_name_button		:ClearAllPoints()
					curr_name_button		:SetPoint("TOPLEFT","BW_Player" .. previousvisibleplayer .. "_Name","BOTTOMLEFT",0,0) -- 0 -5
					previousvisibleplayer	= i

				end

				-----

				BW_Player_GetBuffs(i)

			end

		end

	end


	function BW_Player_GetBuffs(i)

		local firstvisiblebutton = true
		local previousvisiblebutton

		for j=1,16 do

			-----
			local unit

			if math.mod(i,2) == 1 then
				unit = UNIT_IDs[i]
			else
				TargetByName( getglobal("BW_Player" .. i .. "_NameText"):GetText() )
				unit = "target"
			end
			-----

			local texture 				= UnitBuff(unit,j)
			local curr_lock				= getglobal("BW_Player" .. i .. "_Lock")
			local curr_buff				= getglobal("BW_Player" .. i .. "_Buff" .. j)
			local curr_buff_icon		= getglobal("BW_Player" .. i .. "_Buff" .. j .. "Icon")
			local curr_buff_iconpath	= getglobal("BW_Player" .. i .. "_Buff" .. j .. "TexturePath")

			if curr_lock:GetChecked() then

				break

			elseif texture == nil then

				curr_buff			:Hide()
				curr_buff_icon		:Hide()
				curr_buff_iconpath	:Hide()
				curr_buff_iconpath	:SetText( nil )

			elseif texture then

				curr_buff			:Show()
				curr_buff_icon		:SetTexture( texture )
				curr_buff_icon		:Show()
				curr_buff_iconpath	:SetText( texture )
				curr_buff_iconpath	:Hide()

				if firstvisiblebutton then

					curr_lock	:ClearAllPoints()
					curr_lock	:SetPoint("TOPRIGHT","BW_Player" .. i .. "_Name","TOPLEFT",1,-2)
					curr_buff	:ClearAllPoints()
					curr_buff	:SetPoint("TOPLEFT","BW_Player" .. i .. "_NameText","TOPRIGHT",5,2)
					previousvisiblebutton	= j
					firstvisiblebutton		= false

				else

					curr_buff	:ClearAllPoints()
					curr_buff	:SetPoint("TOPLEFT","BW_Player" .. i .. "_Buff" .. previousvisiblebutton,"TOPRIGHT",0,0)
					previousvisiblebutton	= j

				end

			end

		end
		-------------------------
		-------------------------
		local firstvisibledebuff = true
		local previousvisibledebuff

		for j=1,8 do

			-----
			local unit

			if math.mod(i,2) == 1 then
				unit = UNIT_IDs[i]
			else
				TargetByName( getglobal("BW_Player" .. i .. "_NameText"):GetText() )
				unit = "target"
			end
			-----

			local texture 				= UnitDebuff(unit,j)
			local curr_lock				= getglobal("BW_Player" .. i .. "_Lock")
			local curr_buff				= getglobal("BW_Player" .. i .. "_Debuff" .. j)
			local curr_buff_icon		= getglobal("BW_Player" .. i .. "_Debuff" .. j .. "Icon")
			local curr_buff_iconpath	= getglobal("BW_Player" .. i .. "_Debuff" .. j .. "TexturePath")

			if curr_lock:GetChecked() then

				break

			elseif texture == nil then

				curr_buff			:Hide()
				curr_buff_icon		:Hide()
				curr_buff_iconpath	:Hide()
				curr_buff_iconpath	:SetText( nil )

			elseif texture then

				curr_buff			:Show()
				curr_buff_icon		:SetTexture( texture )
				curr_buff_icon		:Show()
				curr_buff_iconpath	:SetText( texture )
				curr_buff_iconpath	:Hide()

				if firstvisiblebutton then

					curr_lock	:ClearAllPoints()
					curr_lock	:SetPoint("TOPRIGHT","BW_Player" .. i .. "_Name","TOPLEFT",1,-2)
					curr_buff	:ClearAllPoints()
					curr_buff	:SetPoint("TOPLEFT","BW_Player" .. i .. "_NameText","TOPRIGHT",5,2)
					previousvisiblebutton	= j
					firstvisiblebutton		= false
					previousvisibledebuff	= j
					firstvisibledebuff		= false

				elseif firstvisibledebuff then

					curr_buff	:ClearAllPoints()
					curr_buff	:SetPoint("TOPLEFT","BW_Player" .. i .. "_Buff" .. previousvisiblebutton,"TOPRIGHT",0,0)
					previousvisibledebuff	= j
					firstvisibledebuff		= false

				else

					curr_buff	:ClearAllPoints()
					curr_buff	:SetPoint("TOPLEFT","BW_Player" .. i .. "_Debuff" .. previousvisibledebuff,"TOPRIGHT",0,0)
					previousvisibledebuff	= j

				end

			end

		end

	end


	function BW_UpdateBuffStatus()

		for i=1,table.getn(UNIT_IDs),2 do
			local playerframe = "BW_Player" .. i

			for j=1,16 do
				if getglobal(playerframe .. "_Buff" .. j):IsVisible() then
					local Flag_BuffFound = false

					for k=1,16 do
						if UnitBuff(UNIT_IDs[i],k) == getglobal(playerframe .. "_Buff" .. j .. "TexturePath"):GetText() then
							Flag_BuffFound = true
						end
					end

					if Flag_BuffFound then
						getglobal(playerframe .. "_Buff" .. j .. "Icon"):SetVertexColor(1,1,1)
					else
						getglobal(playerframe .. "_Buff" .. j .. "Icon"):SetVertexColor(1,0,0)
					end

				end

			end

		end

	end

	function BW_UpdateBuffStatus_Pets()

		for i=2,table.getn(UNIT_IDs),2 do
			local playerframe = "BW_Player" .. i

			if getglobal(playerframe .. "_NameText"):GetText() then
				TargetByName( getglobal(playerframe .. "_NameText"):GetText() )
			end

			for j=1,16 do
				if getglobal(playerframe .. "_Buff" .. j):IsVisible() then
					local Flag_BuffFound = false

					for k=1,16 do
						if UnitBuff("target",k) == getglobal(playerframe .. "_Buff" .. j .. "TexturePath"):GetText() then
							Flag_BuffFound = true
						end
					end

					if Flag_BuffFound then
						getglobal(playerframe .. "_Buff" .. j .. "Icon"):SetVertexColor(1,1,1)
					else
						getglobal(playerframe .. "_Buff" .. j .. "Icon"):SetVertexColor(1,0,0)
					end

				end
			end

		end

		ClearTarget()

	end

	function BW_ResizeWindow()

		local rightcoord = 0
		local bottomcoord = 0
		local width = 0
		local height = 0

		for i=1,table.getn(UNIT_IDs) do

			local curr_name_button		= getglobal("BW_Player" .. i .. "_Name")
			local curr_name_fontstring	= getglobal("BW_Player" .. i .. "_NameText")

			if curr_name_fontstring:GetText() then --isvisible
				bottomcoord = curr_name_button:GetBottom()
			end

			for j=1,16 do
				local curr_buff = getglobal("BW_Player" .. i .. "_Buff" .. j)

				if curr_buff:IsVisible() and curr_buff:GetRight() then
					if curr_buff:GetRight() > rightcoord then
						rightcoord = curr_buff:GetRight()
					end
				end
			end

			for j=1,8 do
				local curr_buff = getglobal("BW_Player" .. i .. "_Debuff" .. j)

				if curr_buff:IsVisible() and curr_buff:GetRight() then
					if curr_buff:GetRight() > rightcoord then
						rightcoord = curr_buff:GetRight()
					end
				end
			end

		end

		if rightcoord then
			width = rightcoord - BuffWatchBackdropFrame:GetLeft()
		end
		if bottomcoord and bottomcoord ~=0 then
			height = BuffWatchBackdropFrame:GetTop() - bottomcoord
		end

		if width > 0 then
			BuffWatchBackdropFrame	:SetWidth(width + 15)
			BuffWatchFrame			:SetWidth(width + 15)
		else
			BuffWatchBackdropFrame	:SetWidth(150)
			BuffWatchFrame			:SetWidth(150)
		end
		if height > 0 then
			BuffWatchBackdropFrame	:SetHeight(height + 15)
			BuffWatchFrame			:SetHeight(height + 15)
		else
			BuffWatchBackdropFrame	:SetHeight(50)
			BuffWatchFrame			:SetHeight(50)
		end

	end

	function BW_TimeControl(Time_Interval, Time_Precision)

		local blah = math.mod( GetTime(),Time_Interval )

		if blah <= Time_Precision then
			return true
		else
			return false
		end

	end

	function BW_MouseIsOverFrame()

		local Flag_MouseIsOverFrame = false

		local cursor_x, cursor_y = GetCursorPosition()
		cursor_x = cursor_x / BuffWatchFrame:GetScale();
		cursor_y = cursor_y / BuffWatchFrame:GetScale();

		if	cursor_x > BuffWatchFrame:GetLeft() and
			cursor_x < BuffWatchFrame:GetRight() and
			cursor_y > BuffWatchFrame:GetBottom() and
			cursor_y < BuffWatchFrame:GetTop() then
			Flag_MouseIsOverFrame = true
		end

		if Flag_MouseIsOverFrame then

			BuffWatchFrameHeader:Show()
			BuffWatchFrameHeaderText:Show()

			for i=1,table.getn(UNIT_IDs) do
				if getglobal("BW_Player" .. i .. "_Name"):IsVisible() then
					getglobal("BW_Player" .. i .. "_Lock"):Show()
				end
			end

		else

			BuffWatchFrameHeader:Hide()
			BuffWatchFrameHeaderText:Hide()

			for i=1,table.getn(UNIT_IDs) do
				getglobal("BW_Player" .. i .. "_Lock"):Hide()
			end

		end

	end


	function BW_Set_UNIT_IDs()

		local Flag_RaidMemberFound = false

		for i=1,40 do

			if UnitName("raid" .. i) then
				Flag_RaidMemberFound = true
				break
			end

		end

		if Flag_RaidMemberFound then

			for i=1,40 do
				UNIT_IDs[2*i-1] = "raid" .. i
			end

			for i=2,80,2 do
				UNIT_IDs[i] = ""
			end

		else

			UNIT_IDs[1] = "player"
			UNIT_IDs[2] = "pet"
			UNIT_IDs[3] = "party1"
			UNIT_IDs[4] = ""
			UNIT_IDs[5] = "party2"
			UNIT_IDs[6] = ""
			UNIT_IDs[7] = "party3"
			UNIT_IDs[8] = ""
			UNIT_IDs[9] = "party4"

		end

	end

-- //////////////////////////////////////////////////////////////////////////////////////
-- //
-- //
-- //				Slash Commands
-- //
-- //
-- //////////////////////////////////////////////////////////////////////////////////////

	function BW_SlashHandler(msg)

		msg = string.lower(msg)

		local index = string.find(msg, " ")

		if index then

			param = string.sub(msg, index+1)
			msg = string.sub(msg, 1, index-1)

		end

		if msg == "alpha" and tonumber(param) and tonumber(param) <= 1 and tonumber(param) >= 0 then

			BuffWatchConfig.alpha = param
			BuffWatchBackdropFrame:SetAlpha( BuffWatchConfig.alpha )
			BW_Print("BuffWatch window opacity set to: " .. BuffWatchConfig.alpha)

		elseif msg == "toggle" then

			BW_Toggle()

		elseif msg == "set" then

			BW_SetRightMouse()

		elseif msg == "showonstartup" then

			BuffWatchConfig.show_on_startup = "yes"
			BW_Print("BuffWatch window will now be shown on startup.", 0.2, 0.9, 0.9 )

		elseif msg == "hideonstartup" then

			BuffWatchConfig.show_on_startup = "no"
			BW_Print("BuffWatch window will now be hidden on startup.", 0.2, 0.9, 0.9 )

		elseif msg == "" or msg == "help" then

			BW_ShowHelp()

		else

			BW_Print(	"BuffWatch: Invalid Command or Parameter")

		end

	end

-- //////////////////////////////////////////////////////////////////////////////////////
-- //
-- //				Slash Command Functions
-- //
-- //////////////////////////////////////////////////////////////////////////////////////

	function BW_Toggle()

		if not BuffWatchFrame:IsVisible() then
			ShowUIPanel(BuffWatchFrame)
		else
			HideUIPanel(BuffWatchFrame)
		end

	end


	function BW_SetRightMouse()

		if lastspellcast == nil then

			BW_Print("   BuffWatch: You have not cast any timed spells yet:")
			BW_Print("            Cast one, and then try \"/bw set\" again")

		else

			for i=1,300 do
				if GetSpellName(i,1) == lastspellcast then
					RMouseSpellID = i
					BuffWatchConfig.rightMouseSpell = i
				end
			end

			if RMouseSpellID then
				BW_Print( format(	"BuffWatch: Right mouse button set to %s (%s)",
									GetSpellName(RMouseSpellID,1) ), 0.2, 0.9, 0.9 )
			end

		end

	end


-- //////////////////////////////////////////////////////////////////////////////////////
-- //
-- //
-- //				Mouse Functions
-- //
-- //
-- //////////////////////////////////////////////////////////////////////////////////////

	function BW_OnMouseDown(arg1)
		if arg1 == "LeftButton" then
			BuffWatchFrame:StartMoving()
		end
	end

	function BW_OnMouseUp(arg1)
		if arg1 == "LeftButton" then
			BuffWatchFrame:StopMovingOrSizing()
		end
	end

	function BW_Name_Clicked(button)
		local index, index2 = string.find( this:GetName(), "BW_Player" )
		local index3 = string.find( this:GetName(), "_Name" )
		local raid_buttonused = string.sub( this:GetName(), index2+1, index3-1 )
		raid_buttonused = tonumber(raid_buttonused)
		local playername = getglobal("BW_Player" .. raid_buttonused .. "_NameText"):GetText()

		if button == "LeftButton" then
			if playername then
				TargetByName( playername )
			end
		elseif button == "RightButton" then
			AssistByName( playername )
		end
	end

	function BW_Buff_Clicked(button)
		local index, index2 = string.find( this:GetName(), "BW_Player" )
		local index3 = string.find( this:GetName(), "_Buff" )

		if index3 == nil then
			index3 = string.find( this:GetName(), "_Debuff" )
		end

		local raid_buttonused = string.sub( this:GetName(), index2+1, index3-1 )
		raid_buttonused = tonumber(raid_buttonused)
		local playername = getglobal("BW_Player" .. raid_buttonused .. "_NameText"):GetText()

		local playerframe = string.sub( this:GetName(), 1, index3-1 )

		if button == "LeftButton" then

			local spellid = nil

			for i=1,300 do
				if GetSpellTexture(i,1) == getglobal(this:GetName() .. "TexturePath"):GetText() then
					spellid = i
				end
			end

			if UnitName("target") and not UnitIsEnemy("target","player") then
				if UnitName("target") ~= playername then
					TargetByName( playername )
				end
			end

			if IsShiftKeyDown() then
				SendChatMessage( format("BW: Casting %s on %s", GetSpellName(spellid,1), playername), "PARTY" )
			end

			if spellid then CastSpell(spellid,1) end

			if SpellIsTargeting() then
				TargetByName( playername )
			end

		elseif button == "RightButton" then

			if not getglobal(playerframe .. "_Lock"):GetChecked() or not IsControlKeyDown() then

				if RMouseSpellID then
					if UnitName("target") and not UnitIsEnemy("target","player") then
						if UnitName("target") ~= playername then
							TargetByName( playername )
						end
					end

					if IsShiftKeyDown() then
						SendChatMessage( format("BW: Casting %s on %s", GetSpellName(RMouseSpellID,1), playername), "PARTY" )
					end

					CastSpell(RMouseSpellID,1)

					if SpellIsTargeting() then
						TargetByName( playername )
					end

				else

					BW_Print(	"   BuffWatch: Right mouse button spell has not yet been set.")
					BW_Print(	"        Cast any spell with a duration. Then type \"/bw set\"")

				end

			elseif getglobal(playerframe .. "_Lock"):GetChecked() and IsControlKeyDown() then

				this:Hide()

				local firstvisiblebutton = true
				local previousvisiblebutton

				for i=1,16 do

					local curr_buff = getglobal(playerframe .. "_Buff" .. i)

					if curr_buff:IsVisible() then

						curr_buff:ClearAllPoints()

						if firstvisiblebutton then
							curr_buff:SetPoint("TOPLEFT",playerframe .. "_NameText","TOPRIGHT",5,2)
							firstvisiblebutton = false
							previousvisiblebutton = i
						else
							curr_buff:SetPoint("TOPLEFT",playerframe .. "_Buff" .. previousvisiblebutton,"TOPRIGHT",0,0)
							previousvisiblebutton = i
						end
					end
				end
				-------------------------
				-------------------------
				local firstvisibledebuff = true
				local previousvisibledebuff

				for i=1,8 do

					local curr_debuff = getglobal(playerframe .. "_Debuff" .. i)

					if curr_debuff:IsVisible() then

						curr_debuff:ClearAllPoints()

						if firstvisiblebutton then

							curr_debuff:SetPoint("TOPLEFT",playerframe .. "_NameText","TOPRIGHT",5,2)
							firstvisiblebutton		= false
							previousvisiblebutton	= i
							firstvisibledebuff		= false
							previousvisibledebuff	= j

						elseif firstvisibledebuff then

							curr_debuff:SetPoint("TOPLEFT",playerframe .. "_Buff" .. previousvisiblebutton,"TOPRIGHT",0,0)
							firstvisibledebuff		= false
							previousvisibledebuff	= i

						else

							curr_debuff:SetPoint("TOPLEFT",playerframe .. "_Debuff" .. previousvisibledebuff,"TOPRIGHT",0,0)
							previousvisibledebuff	= i

						end
					end
				end

				BW_ResizeWindow()

			end

		end

	end

	function BW_BuffTooltip()

			local index, index2 = string.find( this:GetName(), "BW_Player" )
			local index3 = string.find( this:GetName(), "_Buff" )
			if index3 == nil then
				index3 = string.find( this:GetName(), "_Debuff" )
			end
			local id = string.sub( this:GetName(), index2+1, index3-1 )
			id = tonumber(id)


		local buffbuttonid = nil
		local debuffbuttonid = nil
		local texture = getglobal(this:GetName() .. "TexturePath"):GetText()

		for i=1,16 do
			if UnitBuff( UNIT_IDs[id],i ) == texture then
				buffbuttonid = i
			end
		end

		for i_2=1,8 do
			if UnitDebuff( UNIT_IDs[id],i_2 ) == texture then
				debuffbuttonid = i_2
			end
		end

		if buffbuttonid then
			GameTooltip:SetOwner( this, "ANCHOR_BOTTOM" )
			GameTooltip:SetUnitBuff( UNIT_IDs[id], buffbuttonid )
		elseif debuffbuttonid then
			GameTooltip:SetOwner( this, "ANCHOR_BOTTOM" )
			GameTooltip:SetUnitDebuff( UNIT_IDs[id], debuffbuttonid )
		end
	end

-- //////////////////////////////////////////////////////////////////////////////////////
-- //
-- //
-- //				Other Stuff
-- //
-- //
-- //////////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////
-- //
-- // showAllUnitBuffs()
-- //
-- // Purpose: Queries the texture name of a buff
-- // Usage:
-- //		/script showAllUnitBuffs("player")
-- //		/script showAllUnitBuffs("target")
-- // Example Output: Interface\Icons\Spell_Holy_FistOfJustice
-- // Source: http://www.wowwiki.com/Check_Hunter_Aspect
-- //
-- //////////////////////////////////////////////////////////////////////////////////////

	function showAllUnitBuffs(sUnitname)
		local iIterator = 1
		DEFAULT_CHAT_FRAME:AddMessage(format("[%s] Buffs", sUnitname))
		while (UnitBuff(sUnitname, iIterator)) do
			DEFAULT_CHAT_FRAME:AddMessage(UnitBuff(sUnitname, iIterator), 1, 1, 0)
			iIterator = iIterator + 1
		end
	  	DEFAULT_CHAT_FRAME:AddMessage("---", 1, 1, 0)
	end

-- //////////////////////////////////////////////////////////////////////////////////////
-- //
-- //	BuffWatch Print Function
-- //
-- //////////////////////////////////////////////////////////////////////////////////////

	function BW_Print(msg, R, G, B)

		DEFAULT_CHAT_FRAME:AddMessage(msg, R, G, B);

	end

-- //////////////////////////////////////////////////////////////////////////////////////
-- //
-- //	BuffWatch Help
-- //
-- //////////////////////////////////////////////////////////////////////////////////////

	function BW_ShowHelp()

		BW_HelpFrame:Show()
		BW_HelpFrame:ClearAllPoints()
		BW_HelpFrame:SetPoint("CENTER","UIParent","CENTER",0,-32)

		BW_HelpFrame_Text:SetText(

			[[
			                                        - BuffWatch Usage -

			Show/Hide the BuffWatch window:
			   - Bind a keyboard button to show/hide the window
			   - You can also close it by right clicking the "BuffWatch" label (appears on mouseover)

			Showing Buffs:
			   - Left click the BuffWatch label
			   - Also occurs automatically whenever your gain/lose a party or raid member

			Locking a player's watched buffs:
			   - If the checkbox to the left is unchecked, buffs will be added automatically whenever they gain a buff
			   - If checked, buffs will not be added

			Rebuffing:
			   - Left click an icon (will auto-target)

			Right click spell:
			   - Cast any spell with a cast time (not instant). Then type "/bw set"
			   - To cast it, right click any icon (will auto-target)

			Deleting buffs:
			   - Lock the player's buffs (check the box). Then [ CTRL + Right Click ] on the buff

			Slash Commands ( Use /buffwatch or /bw )
			   - /bw alpha # : Set the background opacity (0.0 to 1.0)
			   - /bw toggle : shows/hides the window
			   - /bw [showonstartup / hideonstartup] : set to show or hide the window on startup
			   - /bw : shows this help menu :)

			<< NEW >>
			Verbosity:
			   - Hold [ Shift ] while left or right-clicking a buff icon to send a cast message to your party
			]] )

	end

-- //////////////////////////////////////////////////////////////////////////////////////