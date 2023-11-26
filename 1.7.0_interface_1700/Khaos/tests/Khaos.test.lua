
require('luaunit')
require('WoW.test')
require('..\\..\\Sea\\Sea')
require('..\\..\\Sea\\Sea.io')
require('..\\..\\Sea\\Sea.string')
require('..\\..\\Sea\\Sea.table')
require('..\\..\\Sea\\Sea.util')
require('..\\..\\Chronos\\Chronos')
require('..\\..\\Sea\\Sea.math')
require('..\\localization')
require('..\\Khaos')


TestKhaos = {} --class
	function TestKhaos:setUp()
		-- do nothing
		--
		
		Khaos_Configurations = {
			{ 
				name = "Generic Configuration";
				keywords = {
					default = true;
				};
				configuration = {
					["set1"] = {
						["key1"] = {value="value1";checked=true};
						["key2"] = {value="value2";radio=1};
						["key3"] = {value="value3";slider=.5;};
						["key4"] = {value="value4";};
					};
					["set2"] = {
						["key1"] = {value=.4;};
						["key2"] = {value="/command";checked=false;};
					};
					custom = {
						["MyGlobal"] = {
							a = 1;
							b = 2;
							c = 3;
						};
					};
					sets = {
						["FlexBar"] = false;
						
					};
				};
			};
			{ 
				name = "Alternate Configuration";
				keywords = {
					class = {"WARRIOR"};
					realm = {"Stormscale"};
				};
				configuration = {
					["set1"] = {
						["key1"] = {value="value1b";checked=true};
						["key2"] = {value="value2b";radio=1};
						["key3"] = {value="value3b";slider=.5;};
						["key4"] = {value="value4b";};
					};
					["set2"] = {
						["key1"] = {value=.5;};
						["key2"] = {value="/command2";checked=false;};
					};
					custom = {
						["MyGlobal"] = {
							a = 3;
							b = 2;
							c = 1;
						};
					}
				};
			};
			{ 
				name = "Blackrock Configuration";
				keywords = {
					class = {"MAGE", "HUNTER"};
					realm = {"Blackrock"};
					character = {"Josef"};
				};
				configuration = {
					["set1"] = {
						["key1"] = {value="value1q";checked=true};
						["key2"] = {value="value2q";radio=1};
						["key3"] = {value="value3q";slider=.5;};
						["key4"] = {value="value4q";};
					};
					["set2"] = {
						["key1"] = {value=.5;};
						["key2"] = {value="/command2";checked=false;};
					};
					custom = {
						["MyGlobal"] = {
							a = 2;
							b = 2;
							c = 2;
						};
					}
				};
			};
		}
		
		MyGlobal = nil;
		this = {};
		this.GetName = GetName;
	end

	function TestKhaos:tearDown()
		-- do nothing

	end

	function TestKhaos:test_createConfiguration()		
		local name = "Tested";
		local keywords = {class="Mage"}; 
		
		local id = KhaosCore.createConfiguration(name, keywords);
		local cfg = KhaosCore.getConfiguration(id);
		
		assertEquals(name, cfg.name);
		assertEquals(keywords.class, cfg.keywords.class);
	end

	function TestKhaos:test_copyConfiguration()
		local id = KhaosCore.copyConfiguration(1);
		local orig = KhaosCore.getConfiguration(1);
		local cfg = KhaosCore.getConfiguration(id);

		assertEquals(true, Sea.table.isEquivalent(orig.configuration, cfg.configuration) );
		--Sea.io.printTable(cfg);
	end

	function TestKhaos:test_loadConfiguration()
		assertEquals(nil, MyGlobal);

		KhaosCore.loadConfiguration(1);

		assertEquals('table', type(MyGlobal));		
		assertEquals(1, MyGlobal.a);		
		local value = Khaos.getSetKey("set1", "key1");
		assertEquals("value1", value.value);
		
		KhaosCore.loadConfiguration(2);

		assertEquals('table', type(MyGlobal));		
		assertEquals(3, MyGlobal.a);		
		value = Khaos.getSetKey("set1", "key1");
		assertEquals("value1b", value.value);

		value.value = "value1c";
		Khaos.setSetKey("set1", "key1", value);
		
		KhaosCore.loadConfiguration(2);
		value = Khaos.getSetKey("set1", "key1");
		assertEquals("value1c", value.value);
		
		
	end

	function TestKhaos:test_saveConfiguration()
		assertEquals(nil, MyGlobal);

		Khaos.registerGlobal("MyGlobal");
		KhaosCore.loadConfiguration(1);

		assertEquals('table', type(MyGlobal));		
		assertEquals(1, MyGlobal.a);		
		local value = Khaos.getSetKey("set1", "key1");
		assertEquals("value1", value.value);
		
		KhaosCore.loadConfiguration(2);

		assertEquals('table', type(MyGlobal));		
		assertEquals(3, MyGlobal.a);		
		
		value = Khaos.getSetKey("set1", "key1");
		assertEquals("value1b", value.value);

		value = Sea.table.copy(value);
		value.value = "value1c";

		Khaos.setSetKey("set1", "key1", value );

		value = Khaos.getSetKey("set1", "key1");
		assertEquals("value1c", value.value);
		
		KhaosCore.saveConfiguration();

		value = Khaos.getSetKey("set1", "key1");
		assertEquals("value1c", value.value);

		value.value = "value1d";
		Khaos.setSetKey("set1", "key1", value );
		
		value = Khaos.getSetKey("set1", "key1");
		assertEquals("value1d", value.value);

		Khaos.setSetKeyParameter("set1", "key1", "value", "value1e" );
		
		value = Khaos.getSetKey("set1", "key1");
		assertEquals("value1e", value.value);

		KhaosCore.loadConfiguration(1);
		
		value = Khaos.getSetKey("set1", "key1");
		assertEquals("value1", value.value);
		
	end

	function TestKhaos:test_checkSetKey()
		KhaosCore.loadConfiguration(1);
		assertEquals( true, Khaos.checkSetKey("set1", "key1", "value", "value1") );

		KhaosCore.loadConfiguration(2);
		assertEquals( false, Khaos.checkSetKey("set1", "key1", "value", "value1") );
	end
	
	function TestKhaos:test_Keyword()
		KhaosCore.loadConfiguration(1);
		assertEquals( true, KhaosCore.getKeyword("default") );

		KhaosCore.loadConfiguration(2);
		assertEquals( nil, KhaosCore.getKeyword("default") );
		assertEquals( true, Sea.table.isEquivalent(KhaosCore.getKeyword("realm"), {"Stormscale"} ) );

		KhaosCore.saveConfiguration();
		assertEquals( nil, KhaosCore.getKeyword("default") );		
		assertEquals( true, Sea.table.isEquivalent(KhaosCore.getKeyword("realm"), {"Stormscale"} ) );
		
		KhaosCore.loadConfiguration(1);
		KhaosCore.saveConfiguration();
		assertEquals( true, KhaosCore.getKeyword("default") );
		assertEquals( false, Sea.table.isEquivalent(KhaosCore.getKeyword("realm"), {"Stormscale"} ) );

		-- Sets
		KhaosCore.loadConfiguration(1);
		
		assertEquals( true, KhaosCore.getKeyword("default") );
		
		local newRealm = {"Blackrock"};
		KhaosCore.setKeyword("realm", newRealm);
		
		assertEquals( true, Sea.table.isEquivalent(KhaosCore.getKeyword("realm"), {"Blackrock"} ) );
		
		KhaosCore.loadConfiguration(1);
		
		assertEquals( newRealm, KhaosCore.getKeyword("realm") );
		
		KhaosCore.loadConfiguration(2);
		
		assertEquals( nil, KhaosCore.getKeyword("default") );
		assertEquals( true, Sea.table.isEquivalent(KhaosCore.getKeyword("realm"), {"Stormscale"} ) );
		
		KhaosCore.setKeyword("realm", {"Blackrock"});
		
		assertEquals( true, Sea.table.isEquivalent(KhaosCore.getKeyword("realm"), {"Blackrock"} ) );
		
		KhaosCore.saveConfiguration();
		
		assertEquals( false, Sea.table.isEquivalent(KhaosCore.getKeyword("realm"), {"Stormscale"} ) );
		assertEquals( true, Sea.table.isEquivalent(KhaosCore.getKeyword("realm"), {"Blackrock"} ) );
		
		KhaosCore.loadConfiguration(1);
		KhaosCore.setKeyword("realm", {"Blackrock"});
		
		assertEquals( true, Sea.table.isEquivalent(KhaosCore.getKeyword("realm"), {"Blackrock"} ) );

		KhaosCore.saveConfiguration();
		assertEquals( true, KhaosCore.getKeyword("default") );
		assertEquals( false, Sea.table.isEquivalent(KhaosCore.getKeyword("realm"), {"Stormscale"} ) );
		assertEquals( true, Sea.table.isEquivalent(KhaosCore.getKeyword("realm"), {"Blackrock"} ) );
	end

	function TestKhaos:test_matchKeyword()
		local none = KhaosCore.matchKeywords({});

		assertEquals( 1, none[1].id );
		
		local war = KhaosCore.matchKeywords({class="WARRIOR"});
		assertEquals( 2, war[1].id );

		local realm = KhaosCore.matchKeywords({realm="Stormscale"});
		assertEquals( 2, realm[1].id );

		local hunt = KhaosCore.matchKeywords({class="WARRIOR", character="Josef", realm="Blackrock"});
		assertEquals( 3, hunt[1].id );
		assertEquals( 2, hunt[2].id );
	end
	
	function TestKhaos:test_registerGlobal()
		MyTest = 123;
		MyGlobal = nil;
		
		KhaosCore.loadConfiguration(1);
		KhaosCore.saveConfiguration();

		assertEquals(nil, MyGlobal);
		Khaos.registerGlobal("MyGlobal");
		assertEquals(nil, MyGlobal);
		
		KhaosCore.loadConfiguration(1);
		KhaosCore.saveConfiguration();
		
		assertEquals("table",type(MyGlobal) );

		MyGlobal = nil;
		assertEquals(nil, MyGlobal);
		Khaos.unregisterGlobal("MyGlobal");
		assertEquals(nil, MyGlobal);
		
		KhaosCore.loadConfiguration(1);
		KhaosCore.saveConfiguration();

		assertEquals(nil, MyGlobal);
	end

	function TestKhaos:test_copyConfiguration()
		local id = KhaosCore.copyConfiguration(2);

		assertEquals(false, Sea.table.isEquivalent( KhaosCore.getConfiguration(id), KhaosCore.getConfiguration(2) ) );
		assertEquals(true, Sea.table.isEquivalent( KhaosCore.getConfiguration(id).configuration, KhaosCore.getConfiguration(2).configuration ) );
		assertEquals(true, Sea.table.isEquivalent( KhaosCore.getConfiguration(id).keywords, KhaosCore.getConfiguration(2).keywords ) );
	end

	function TestKhaos:test_registerFolder()
		local folder = {
			id = "AmazingFolderID";
			text = "Amazing Options";
			helptext = " The options contained in this folder are the worst options possible. No man or woman on earth should ever concievably use them except when under the most dire of data manipulation circumstances!";
			difficulty = 4;
		};

		Khaos.registerFolder(folder);

		assertEquals( KhaosData.configurationFolders["AmazingFolderID"].text, folder.text);
		assertEquals( KhaosData.configurationFolders["AmazingFolderID"].helptext, folder.helptext);
		assertEquals( KhaosData.configurationFolders["AmazingFolderID"].difficulty, folder.difficulty);
	end

	function TestKhaos:test_parseEncodedSlashString()
		local words = { "one", "two", "three", "four", "5", "6", 'true', 'false' };
		local phrase1 = "%1";
		local phrase2 = "%5d";
		local phrase3 = "%7b";
		local phrase4 = "%8b";
		local phrase7 = "!key1.checked";
		local phrase5 = "$key1.checked$";
		local phrase6 = "%1 %4 %5s %6 %7b %8 %9 $key1.value$ $key1.checked$ !key1.checked ~key1.checked";

		local set = "set1";

		local output1 = KhaosCore.processEncodedSlashString(phrase1, words, set);
		assertEquals ( "one", output1 );

		local output2 = KhaosCore.processEncodedSlashString(phrase2, words, set);
		assertEquals ( 5, output2 );
		
		local output3 = KhaosCore.processEncodedSlashString(phrase3, words, set);
		assertEquals ( true, output3 );
		
		local output4 = KhaosCore.processEncodedSlashString(phrase4, words, set);
		assertEquals ( false, output4 );
		
		local output5 = KhaosCore.processEncodedSlashString(phrase5, words, set);
		assertEquals ( true, output5 );
		
		local output7 = KhaosCore.processEncodedSlashString(phrase7, words, set);
		assertEquals ( false, output7 );
		
		local output6 = KhaosCore.processEncodedSlashString(phrase6, words, set);
		assertEquals ( "one four 5 6 true false <No Word> value1 true false false", output6 );
		
	end
	
	function TestKhaos:test_registerOptionSet()
		local folder = {
			id = "AmazingFolderID";
			text = "Amazing Options";
			helptext = " The options contained in this folder are the worst options possible. No man or woman on earth should ever concievably use them except when under the most dire of data manipulation circumstances!";
			difficulty = 4;
		};

		Khaos.registerFolder(folder);

		local optionSet = {
			id = "BasicSetID";
			text = " Basic AddOn ";
			helptext = " Basic AddOn allows you to do simple things, like clean shoes, polish rubber, and shine your sword.";
			difficulty = 1;
			options = {};
			commands = {};
		};

		local option1 = {
			id = "NormalCheckbox1";
			key = "key1";
			value = "12";
			text = "Check me";
			helptext = "Checking this checkbox will help ensure world-hunger.";
			callback = function (state) Sea.io.error ( "Checkbox is checked? ", state.checked ) end;
			feedback = function (state) 
				if ( state.checked ) then
					return "World hunger activate";
				else
					return "World hunger is a myth";
				end
			end;
			check = true;
			type = K_TEXT;
			default = {
				checked = true;
			};
			disabled = {
				checked = false;
			};
		};
		table.insert(optionSet.options, option1);
		
		local option2 = {
			id = "NormalSlider2";
			key = "Key2";
			text = "Slider me";
			helptext = "Sliding this slider will slip entropy out of whack.";
			callback = function (state) Sea.io.error ( "Slider state? ", state.slider ) end;
			feedback = function (state) 
				if ( state.slider < .5 ) then
					return "We're cooling down";
				else
					return "We're going to burn up";
				end
			end;
			type = K_SLIDER;
			setup = {
				sliderMin = 0;
				sliderMax = 1;
				sliderStep = .1;
			};
			default = {
				checked = true;
				slider = .5;
			};
			disabled = {
				checked = false;
				slider = 0;
			};
		};
		table.insert(optionSet.options, option2);

		
		local option3 = {
			id = "NormalPulldown3";
			key = "Key3";
			value = "12";
			text = "Pull me";
			helptext = "Selecting things from this pulldown is cool.";
			callback = function (state) Sea.io.error ( "Pulldown options: "); Sea.io.printTable(state.options); end;
			feedback = function (state) 
				local count = 0;
				for k,v in state.options do 
					count = count + 1;
				end
				if ( count < 3 ) then
					return "Only a couple things are selected";
				else
					return "3 or more things selected! You're cool!";
				end
			end;
			type = K_PULLDOWN;
			setup = {
				options = {
					["A"] = 1,
					["B"] = 2,
					["C"] = 3,
					["D"] = 4
				};
				multiSelect = false;
			};
			default = {
				options = {
					1,
					2
				};
			};
			disabled = {
				options = {
					3
				};
			};
		};
		table.insert(optionSet.options, option3);

		
		local option4 = {
			id = "NormalEditbox4";
			key = "Key4";
			value = "Abcdefg";
			text = "Edit me";
			helptext = "Typing stuff in here is fun";
			callback = function (state) Sea.io.error ( "editbox text: ", state.value, " called on ", state.action ); end;
			feedback = function (state) 
				return "You've currently entered: ", state.value;
			end;
			type = K_EDITBOX;
			setup = {
				callOn = {"enter"};
			};
			default = {
				value="abc124";
			};
			disabled = {
				value="";
			};
		};
		table.insert(optionSet.options, option4);

		local command1 = {
			id = "KhaosDemo1";
			commands = { "/foo", "/foobar" };
			helpText = "Demo command for my world.";
			parseTree = {
				boo = {
					[1] = {
						key = "key1";
						stringMap = {
							red = { checked=false };
							blue = { checked=true };
							custom = { checked="%2b" };
							toggle = { checked="!key1.checked" };
						};
					}
				}
			};
		};

		table.insert(optionSet.commands, command1);

		Khaos.registerOptionSet( folder.id, optionSet );

		local key;
		KhaosCore.processSlashCommand("boo red bar baz", "/foo", command1.parseTree, "set1" );
		key = Khaos.getSetKey("set1", "key1");
		assertEquals(false, key.checked);
		
		KhaosCore.processSlashCommand("boo blue", "/foo", command1.parseTree, "set1" );
		key = Khaos.getSetKey("set1", "key1");
		assertEquals(true, key.checked);

		KhaosCore.processSlashCommand("boo custom true", "/foo", command1.parseTree, "set1" );
		key = Khaos.getSetKey("set1", "key1");
		assertEquals(true, key.checked);

		KhaosCore.processSlashCommand("boo custom false", "/foo", command1.parseTree, "set1" );
		key = Khaos.getSetKey("set1", "key1");
		assertEquals(false, key.checked);

		KhaosCore.processSlashCommand("boo toggle", "/foo", command1.parseTree, "set1" );
		key = Khaos.getSetKey("set1", "key1");
		assertEquals(true, key.checked);

		--Sea.io.printTable(KhaosData);
	end
	
luaUnit:run();
