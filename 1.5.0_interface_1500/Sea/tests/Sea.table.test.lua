
require('luaunit')
require('..\\Sea.lua')
require('..\\Sea.table.lua')

TestSeaTable = {} --class

	function TestSeaTable:setUp()
		-- do nothing
	end

	function TestSeaTable:tearDown()
		-- do nothing
	end

	function TestSeaTable:test_getValueIndex()
		assertEquals("fix me", "please");
	end
	
	function TestSeaTable:test_isInTable()
		assertEquals("fix me", "please");
	end
	
	function TestSeaTable:test_isStringInTableValue()
		assertEquals("fix me", "please");
	end

	function TestSeaTable:test_push()
		assertEquals("fix me", "please");
	end

	function TestSeaTable:test_pop()
		assertEquals("fix me", "please");
	end

-- class TestSeaTable

luaUnit:run()
