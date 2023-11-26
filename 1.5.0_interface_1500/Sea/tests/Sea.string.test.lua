
require('luaunit')
require('..\\Sea.lua')
require('..\\Sea.util.lua')
require('..\\Sea.string.lua')

TestSeaString = {} --class

	function TestSeaString:setUp()
		-- do nothing
	end

	function TestSeaString:tearDown()
		-- do nothing
	end

	function TestSeaString:test_byte()
		local b = Sea.string.byte("b");
		assertEquals("<62>", b);
	end
	
	function TestSeaString:test_toInt()
		local inta = Sea.string.toInt("11");
		assertEquals(11, inta);
	end
	
	function TestSeaString:test_fromTime()
		local time = Sea.string.fromTime(1344321.12,2);
		assertEquals("373:25:21.12", time);
	end

	function TestSeaString:test_capitalizeWords()
		local phrase = Sea.string.capitalizeWords("hello world you great world.");
		assertEquals("Hello World You Great World.", phrase);
	end

-- class TestSeaString

luaUnit:run()
