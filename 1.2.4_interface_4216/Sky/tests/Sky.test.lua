function getglobal()
	return true;
end

ChatFrame1 = {};
RED_FONT_COLOR = {r=1,g=0,b=0};
NORMAL_FONT_COLOR = {r=1,g=1,b=1};

function ChatFrame1.AddMessage (me, msg, r,g,b,a)
	print(msg);
end

UIErrorsFrame = ChatFrame1;

require('luaunit')
require('..\\..\\Sea\\Sea.lua')
require('..\\..\\Sea\\Sea.io.lua')
require('..\\..\\Sea\\Sea.string.lua')
require('..\\..\\Sea\\Sea.table.lua')
require('..\\..\\Sea\\Sea.util.lua')
require('..\\..\\Chronos\\Chronos.lua')
require('..\\..\\Sea\\Sea.math.lua')
require('..\\localization.lua')
require('..\\Sky.lua')

function GetTime()
	return 1;
end

function GetLocale()
	return "enUS";
end

function GetRealZoneText()
	return "Yoshi's Island";
end

function UnitName(unit) 
	if ( unit == "player" ) then 
		return PLAYER_NAME;
	elseif ( unit == "party1" ) then 
		return PARTY_MEMBERS[1];
	elseif ( unit == "party2" ) then 
		return PARTY_MEMBERS[2];
	elseif ( unit == "party3" ) then 
		return PARTY_MEMBERS[2];
	elseif ( unit == "party4" ) then 
		return PARTY_MEMBERS[4];
	end
end

function IsRaidLeader()
	return IS_RAID_LEADER;
end

function GetNumPartyMembers()
	return PARTY_COUNT;
end

function GetNumRaidMembers()
	return RAID_COUNT;
end

function GetPartyLeaderIndex()
	return PARTY_LEADER_INDEX;
end

function GetRaidRosterInfo(i)
	--print ( i, RAID_MEMBERS[i].name, RAID_MEMBERS[i].rank, RAID_MEMBERS[i].subgroup );
	return RAID_MEMBERS[i].name, RAID_MEMBERS[i].rank, RAID_MEMBERS[i].subgroup;
end

function SendChatMessage(msg, system, language, target)	
	print( msg, system, language, target);
end

TestSky = {} --class
	function TestSky:setUp()
		-- do nothing
		--
		TestTable = {{a=1;b={"asdf",4,6,7,412,12}}, 2, "3"};
		Sky.sendPure("Yo");
		Sky.sendMessage("Yoda");
		Sky.sendTable( TestTable );

		
		RAID_MEMBERS = {
			[1] = { name="Alex",rank=1,subgroup=1 };
			[2] = { name="Bill",rank=0,subgroup=1 };
			[3] = { name="Joe",rank=1,subgroup=2 };
			[4] = { name="Tom",rank=2,subgroup=2 };
			[5] = { name="Sam",rank=0,subgroup=3 };
			[6] = { name="Zol",rank=0,subgroup=3 };
		};
		PARTY_MEMBERS = {
			"Alex",
			"Joe",
			"Bill"
		};

		PLAYER_NAME = "Zol";
		IS_RAID_LEADER = false;
		PARTY_LEADER_INDEX = 1;
		PARTY_COUNT = 4;
		RAID_COUNT = 6;
	end

	function TestSky:tearDown()
		-- do nothing

		SkyDeliveryMan.outbox = {};
		SkyDeliveryMan.outgoingDatagrams = {};
		SkyDeliveryMan.sendDatagrams = {};
		SkyDeliveryMan.messageID = 0;
	end

	function TestSky:test_packageDatagram()		
		local str = SkyDeliveryMan.packageDatagram(SkyDeliveryMan.outgoingDatagrams[1]);
		assertEquals("Yo", str);

		local str2 = SkyDeliveryMan.packageDatagram(SkyDeliveryMan.outgoingDatagrams[2]);
		assertEquals("<SkySM> [] 2 1/1 {4} ("..SKY_TIME_TO_LIVE..") ".."Yoda", str2);

		local str3 = SkyDeliveryMan.packageDatagram(SkyDeliveryMan.outgoingDatagrams[3]);
		assertEquals("<SkyST> [] 3 1/2 {219} ("..SKY_TIME_TO_LIVE..") "..string.sub(Sea.string.objectToString(TestTable), 1, SKY_MAX_DATAGRAM_LENGTH), str3);
end

	function TestSky:test_unwrapDatagram()		
		local str = SkyDeliveryMan.packageDatagram(SkyDeliveryMan.outgoingDatagrams[1]);
		local datagram = SkyPostOffice.unwrapDatagram(str);

		for k,v in datagram do 
			print( "k: ", k, " v: ", v);
		end
		assertEquals("Yo", datagram.data);

		local str2 = SkyDeliveryMan.packageDatagram(SkyDeliveryMan.outgoingDatagrams[2]);
		local datagram2 = SkyPostOffice.unwrapDatagram(str2);

		for k,v in datagram2 do 
			print( "k: ", k, " v: ", v);
		end
		assertEquals("Yoda", datagram2.data);

		local str3 = SkyDeliveryMan.packageDatagram(SkyDeliveryMan.outgoingDatagrams[3]);
		local datagram3 = SkyPostOffice.unwrapDatagram(str3);

		for k,v in datagram3 do 
			print( "k: ", k, " v: ", v);
		end

		assertEquals(string.sub(Sea.string.objectToString(TestTable), 1, SKY_MAX_DATAGRAM_LENGTH), datagram3.data);
	end

	function TestSky:test_convertToZoneChannelName()
		local name = "general";
		local name2 = "zoltac";
		local name3 = "WorldDefense";

		local zonedName = SkyChannelManager.convertToZoneChannelName(name);
		local zonedName2 = SkyChannelManager.convertToZoneChannelName(name2);
		local zonedName3 = SkyChannelManager.convertToZoneChannelName(name3);

		assertEquals("General - Yoshi's Island", zonedName);
		assertEquals(name2, zonedName2);
		assertEquals(name3, zonedName3);
	end


	function TestSky:test_getLeaderCommands()
		
		-- In a Raid
		assertEquals("Sam", SkyTools.getPartyLeaderName() );
		assertEquals("Tom", SkyTools.getRaidLeaderName() );

		-- You are the raid leader
		IS_RAID_LEADER = true;
		assertEquals("Zol", SkyTools.getRaidLeaderName() );
		IS_RAID_LEADER = false;

		-- Party Only
		RAID_COUNT = 0;
		assertEquals("Alex", SkyTools.getPartyLeaderName() );

		-- Solo
		PARTY_COUNT = 0;
		assertEquals("Zol", SkyTools.getPartyLeaderName() );
	end
	
	function TestSky:test_realChannelNames()		
		assertEquals("Sky", SkyChannelManager.convertToRealChannelName(SKY_CHANNEL) );

		-- In a Raid
		assertEquals("SkyRaidTom", SkyChannelManager.convertToRealChannelName(SKY_RAID) );
		assertEquals("SkyPartySam", SkyChannelManager.convertToRealChannelName(SKY_PARTY) );
		
		RAID_COUNT = 0;
		
		-- In a party, left raid
		assertEquals("SkyRaidZol", SkyChannelManager.convertToRealChannelName(SKY_RAID) );
		assertEquals("SkyPartyAlex", SkyChannelManager.convertToRealChannelName(SKY_PARTY) );

		PARTY_COUNT = 0;

		-- Solo
		assertEquals("SkyPartyZol", SkyChannelManager.convertToRealChannelName(SKY_PARTY) );

		-- Zone
		assertEquals("SkyZoneYoshi", SkyChannelManager.convertToRealChannelName(SKY_ZONE) );
	end

	function TestSky:test_convertToChannelIdentifier()
		assertEquals(SKY_CHANNEL, SkyChannelManager.convertToChannelIdentifier("Sky"));

		assertEquals(SKY_RAID, SkyChannelManager.convertToChannelIdentifier("SkyRaidSalamando"));
		assertEquals(SKY_PARTY, SkyChannelManager.convertToChannelIdentifier("SkyPartyTom"));
		assertEquals(SKY_ZONE, SkyChannelManager.convertToChannelIdentifier("SkyZoneHarry"));

		assertEquals(SKY_RAID, SkyChannelManager.convertToChannelIdentifier("SkyRaid"));
		assertEquals(SKY_PARTY, SkyChannelManager.convertToChannelIdentifier("SkyParty"));
		assertEquals(SKY_ZONE, SkyChannelManager.convertToChannelIdentifier("SkyZone"));

	end
luaUnit:run();
