SEARCH_STRING_MIN = "%(%d+ min%)";
SEARCH_STRING_SEC = "%((%d+) sec%)";

if ( GetLocale() == "deDE" ) then
	SEARCH_STRING_MIN = "%(%d+ Min%.%)";
	SEARCH_STRING_SEC = "%((%d+) Sek%.%)";
end