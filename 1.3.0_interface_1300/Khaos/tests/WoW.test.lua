function getglobal(key)
	return _G[key];
end

function setglobal( key, value ) 
	_G[key] = value;
	setfenv(0, _G );
end

ChatFrame1 = {};
RED_FONT_COLOR = {r=1,g=0,b=0};
NORMAL_FONT_COLOR = {r=1,g=1,b=1};

function ChatFrame1.AddMessage (me, msg, r,g,b,a)
	print(msg);
end

UIErrorsFrame = ChatFrame1;

function GetName(self)
	if ( self ) then
		if ( self.name ) then 
			return self.name;
		else
			return "TestProgram";
		end
	end

	return nil;
end
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

-- Globals
--
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

