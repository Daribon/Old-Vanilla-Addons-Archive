--Version
SCT_Version = "v3.5";

--Everything From here on would need to be translated and put
--into if statements for each specific language.

--***********
--ENGLISH
--***********

-- Static Messages
SCT_DodgeMsg = "Dodge!";					-- Message to be displayed when you dodge
SCT_ParryMsg = "Parry!";					-- Message to be displayed when you parry
SCT_BlockMsg = "Block!";					-- Message to be displayed when you block
SCT_MissMsg = "Missed!";					-- Message to be displayed when you are missed
SCT_ResistMsg = "Resisted!";			-- Message to be displayed when you resist
SCT_DeflectMsg = "Deflected!" 		-- Message to be displayed when you deflect
SCT_Absorb= "Absorbed!";					-- Message to be displayed when you Absorb
SCT_LowHP= "Low Health!";					-- Message to be displayed when HP is low
SCT_LowMana= "Low Mana!";					-- Message to be displayed when Mana is Low
SCT_SelfFlag = "*";								-- Icon to show self hits
SCT_Berserk = "Berserk Now!";			-- Message to be displayed when Troll's Berserking ability is Available
SCT_Combat = "+Combat";						-- Message to be displayed when entering combat
SCT_NoCombat = "-Combat";					-- Message to be displayed when leaving combat
SCT_ComboPoint = "CP";			  		-- Message to be displayed when gaining a combo point
SCT_FiveCPMessage = "Finish It!"; -- Message to be displayed when you have 5 combo points
SCT_Honor = "Honor";							-- Message to be displayed when gaining hnor/contribution points

--startup messages
SCT_STARTUP = "Scrolling Combat Text "..SCT_Version.." AddOn loaded. Type /sct for options.";
SCT_Options = "SCT Options";

--nouns
SCT_YOU = "You ";
SCT_YOU_GAIN = "You gain ";
SCT_YOU_FADE = " fades from you";
SCT_TARGET = "Target ";
SCT_AFFLICTED_BY = "You are afflicted by ";
SCT_PROFILE = "SCT Profile Loaded: |cff00ff00";

--Search Messages
SCT_ABSORB_AMOUNT_SEARCH = "hits you for (%d+) (.+)";
SCT_BLOCK_AMOUNT_SEARCH = "hits you for (%d+). (.+)";
SCT_BLOCK_SEARCH = "blocked";
SCT_DEBUFF_NAME_SEARCH = "You are afflicted by (.+).";
SCT_YOU_GAIN_AMOUNT_SEARCH = "You (%w+) (%d+) (%w+)"; 
SCT_YOU_GAIN_SEARCH = "You gain (.+).";
SCT_HONOR_SEARCH = "Estimated Honor Points: (%d+)";
SCT_FADE_SEARCH = "(.+) fades from you.";

--Useage
SCT_DISPLAY_USEAGE = "Useage: \n";
SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'message' (for white text)\n";
SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'message' red(0-10) green(0-10) blue(0-10)\n";
SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Example: /sctdisplay 'Heal Me' 10 0 0\nThis will display 'Heal Me' in bright red\n";
SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Some Colors: red = 10 0 0, green = 0 10 0, blue = 0 0 10,\nyellow = 10 10 0, magenta = 10 0 10, cyan = 0 10 10";

--Event and Damage option values
SCT_OPTION_EVENT1 = {name = "Show Damage", tooltipText = "Enables or Disables melee and misc. (fire, fall, etc...) damage"};
SCT_OPTION_EVENT2 = {name = "Show Misses", tooltipText = "Enables or Disables melee misses"};
SCT_OPTION_EVENT3 = {name = "Show Dodges", tooltipText = "Enables or Disables melee dodges"};
SCT_OPTION_EVENT4 = {name = "Show Parries", tooltipText = "Enables or Disables melee parries"};
SCT_OPTION_EVENT5 = {name = "Show Blocks", tooltipText = "Enables or Disables melee blocks and partial blocks"};
SCT_OPTION_EVENT6 = {name = "Show Spells Damage", tooltipText = "Enables or Disables spell damage"};
SCT_OPTION_EVENT7 = {name = "Show Spell Heals", tooltipText = "Enables or Disables spell heals"};
SCT_OPTION_EVENT8 = {name = "Show Spell Resists", tooltipText = "Enables or Disables spell resists"};
SCT_OPTION_EVENT9 = {name = "Show Debuffs", tooltipText = "Enables or Disables showing when you get debuffs"};
SCT_OPTION_EVENT10 = {name = "Show Absorb", tooltipText = "Enables or Disables showing when monsters damage is absorbed"};
SCT_OPTION_EVENT11 = {name = "Show Low HP", tooltipText = "Enables or Disables showing when you have low health"};
SCT_OPTION_EVENT12 = {name = "Show Low Mana", tooltipText = "Enables or Disables showing when you have low mana"};
SCT_OPTION_EVENT13 = {name = "Show Power Gains", tooltipText = "Enables or Disables showing when you gain Mana, Rage, Energy\nfrom potions, items, buffs, etc...(Not regular regen)"};
SCT_OPTION_EVENT14 = {name = "Show Combat Flags", tooltipText = "Enables or Disables showing when you enter or leave combat"};
SCT_OPTION_EVENT15 = {name = "Show Combo Point Gains", tooltipText = "Enables or Disables showing when you gain combo points"};
SCT_OPTION_EVENT16 = {name = "Show Honor Contribution", tooltipText = "Enables or Disables showing when you gain Honor Contribution points"};
SCT_OPTION_EVENT17 = {name = "Show Buffs", tooltipText = "Enables or Disables showing when you gain buffs"};
SCT_OPTION_EVENT18 = {name = "Show Buff Fades", tooltipText = "Enables or Disables showing when you lose buffs"};

--Check Button option values
SCT_OPTION_CHECK1 = { name = "Enable Scrolling Combat Text", tooltipText = "Enables or Disables the Scrolling Combat Text"};
SCT_OPTION_CHECK2 = { name = "Flag Combat Text", tooltipText = "Enables or Disables placing a * around all Scrolling Combat Text"};
SCT_OPTION_CHECK3 = { name = "Show Events as Message", tooltipText = "Enables or Disables making events display (dodge, etc...)\nas static text messages on screen (not scrolling)"};
SCT_OPTION_CHECK4 = { name = "Scroll Text Down", tooltipText = "Enables or Disables scrolling text downwards"};
SCT_OPTION_CHECK5 = { name = "Sticky Crits", tooltipText = "Enables or Disables having crtical hits/heals stick above your head"};
SCT_OPTION_CHECK6 = { name = "Spell Damage Type", tooltipText = "Enables or Disables showing spell damage type"};

--Slider options values
SCT_OPTION_SLIDER1 = { name="Text Animation Speed", minText="Faster", maxText="Slower", tooltipText = "Controls the speed at which the text animation scrolls"};
SCT_OPTION_SLIDER2 = { name="Text Size", minText="Smaller", maxText="Larger", tooltipText = "Controls the size of the scrolling text"};
SCT_OPTION_SLIDER3 = { name=" ", minText="10%", maxText="90%", tooltipText = "Controls the % of health needed to give a warning"};
SCT_OPTION_SLIDER4 = { name="  ",  minText="10%", maxText="90%", tooltipText = "Controls the % of mana needed to give a warning"};
SCT_OPTION_SLIDER5 = { name="Text Opacity", minText="0%", maxText="100%", tooltipText = "Controls the opacity of the text"};

-- Cosmos button
SCT_CB_NAME			= "Scrolling Combat Text".." "..SCT_Version;
SCT_CB_SHORT_DESC	= "by Grayhoof";
SCT_CB_LONG_DESC	= "Pops up useful combat messages above your head - try it!";
SCT_CB_ICON			= "Interface\\Icons\\Spell_Shadow_EvilEye"; -- "Interface\\Icons\\Spell_Shadow_FarSight"