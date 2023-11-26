--[[
--	LookLock Localization
--		"English Localization"
--	
--	English By: Mugendai
--	Contact: mugekun@gmail.com
--	
--	$Id: localization.lua 2538 2005-09-29 00:51:52Z mugendai $
--	$Rev: 2538 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-09-28 19:51:52 -0500 (Wed, 28 Sep 2005) $
--]]

-- <= == == == == == == == == == == == == =>
--------------------------------------------------
--
-- Binding Strings
--
--------------------------------------------------
BINDING_HEADER_LOOKLOCKHEADER		= "Look Lock";
BINDING_NAME_LOOKLOCK			= "Look Lock On/Off";
BINDING_NAME_LOOKLOCKPUSH		= "Look Lock Hold";
BINDING_NAME_CAMERALOCK			= "Camera Lock On/Off";
BINDING_NAME_CAMERALOCKPUSH		= "Camera Lock Hold";
BINDING_NAME_LOOKLOCKACTION		= "Look Lock Action";
BINDING_NAME_LOOKLOCKCAMERA		= "Look Lock Camera";

--------------------------------------------------
--
-- UI Strings
--
--------------------------------------------------
LOOKLOCK_CONFIG_HEADER			= "Look Lock";
LOOKLOCK_CONFIG_HEADER_INFO		= "These options configure Look Lock.";
LOOKLOCK_CONFIG_REMAP		= "Mouse Button Control";
LOOKLOCK_CONFIG_REMAP_INFO	= "Allows better behavior of mouse buttons when using Look Lock.";
LOOKLOCK_CONFIG_STRAFE		= "Mouse Button Strafe";
LOOKLOCK_CONFIG_STRAFE_INFO	= "Makes the left and right mouse buttons strafe left and right when in look lock mode.";
LOOKLOCK_CONFIG_SELECT		= "Select Mode";
LOOKLOCK_CONFIG_SELECT_INFO	= "If enabled, when in look lock mode, the left button will give a targeting cursor, instead of rotating the camera.";
LOOKLOCK_CONFIG_CURSOR		= "Show Targeting Cursor";
LOOKLOCK_CONFIG_CURSOR_INFO	= "If enabled, a targeting cursor will be shown while in look lock mode.";
LOOKLOCK_CONFIG_EASYLOOK		= "Easy Look Lock";
LOOKLOCK_CONFIG_EASYLOOK_INFO	= "If enabled, look lock mode will be turned on when you hold your right mouse for more than the selected time then release.";
LOOKLOCK_CONFIG_EASYLOOK_SUFFIX	= "sec(s)";
LOOKLOCK_CONFIG_EASYCAMERA		= "Easy Camera Lock";
LOOKLOCK_CONFIG_EASYCAMERA_INFO	= "If enabled, camera lock mode will be turned on when you hold your left mouse for more than the selected time then release.";
LOOKLOCK_CONFIG_EASYCAMERA_SUFFIX	= "sec(s)";
LOOKLOCK_CONFIG_ALWAYS_SEP		= "Always Look Mode";
LOOKLOCK_CONFIG_ALWAYS_SEP_INFO	= "Options for Look Lock, Always Look Mode.";
LOOKLOCK_CONFIG_ALWAYS		= "Always Look(Caution)";
LOOKLOCK_CONFIG_ALWAYS_INFO	= "This will make your mouse always be in Look Lock mode, right clicking will return to normal mode, use with caution.";
LOOKLOCK_CONFIG_LOOKTIME	= "Look Time";
LOOKLOCK_CONFIG_LOOKTIME_INFO	= "Sets the amount of time the mouse must be within an auto lookable state, to enter look mode, when using always look mode.";
LOOKLOCK_CONFIG_LOOKTIME_TEXT	= "Second(s)";
LOOKLOCK_CONFIG_USEAREA		= "Use Look Area";
LOOKLOCK_CONFIG_USEAREA_INFO	= "If this is enabled, then the mouse will have to be within the look area to turn back to look mode, while in always look mode.";
LOOKLOCK_CONFIG_AREAWIDTH	= "Area Width";
LOOKLOCK_CONFIG_AREAWIDTH_INFO	= "Sets the width of the look area.  In percentage of screen width.";
LOOKLOCK_CONFIG_AREAWIDTH_TEXT	= "Percent of Screen Width";
LOOKLOCK_CONFIG_AREAWIDTH_SUFFIX	= "%";
LOOKLOCK_CONFIG_AREAHEIGHT	= "Area Height";
LOOKLOCK_CONFIG_AREAHEIGHT_INFO	= "Sets the height of the look area.  In percentage of screen height.";
LOOKLOCK_CONFIG_AREAHEIGHT_TEXT	= "Percent of Screen Height";
LOOKLOCK_CONFIG_AREAHEIGHT_SUFFIX	= "%";
LOOKLOCK_CONFIG_AREAHOFF	= "Area Horizontal Offset";
LOOKLOCK_CONFIG_AREAHOFF_INFO	= "Sets the horizontal offset of the look area.  In percent of screen width off the center.";
LOOKLOCK_CONFIG_AREAHOFF_TEXT	= "Percent Off Center";
LOOKLOCK_CONFIG_AREAHOFF_SUFFIX	= "%";
LOOKLOCK_CONFIG_AREAVOFF	= "Area Vertical Offset";
LOOKLOCK_CONFIG_AREAVOFF_INFO	= "Sets the vertical offset of the look area.  In percent of screen height off the center.";
LOOKLOCK_CONFIG_AREAVOFF_TEXT	= "Percent Off Center";
LOOKLOCK_CONFIG_AREAVOFF_SUFFIX	= "%";
LOOKLOCK_CONFIG_CURSOR_NAME		= "Targeting Cursor";
LOOKLOCK_CONFIG_AREA_NAME	= "Look Lock Area";

--------------------------------------------------
--
-- Chat Strings
--
--------------------------------------------------
LOOKLOCK_CHAT_REMAP			= LOOKLOCK_CONFIG_REMAP;
LOOKLOCK_CHAT_STRAFE			= LOOKLOCK_CONFIG_STRAFE;
LOOKLOCK_CHAT_SELECT			= LOOKLOCK_CONFIG_SELECT;
LOOKLOCK_CHAT_CURSOR			= LOOKLOCK_CONFIG_CURSOR;
LOOKLOCK_CHAT_ALWAYS			= LOOKLOCK_CONFIG_ALWAYS;
LOOKLOCK_CHAT_LOOKTIME			= LOOKLOCK_CONFIG_LOOKTIME;
LOOKLOCK_CHAT_USEAREA			= LOOKLOCK_CONFIG_USEAREA;
LOOKLOCK_CHAT_AREAWIDTH			= LOOKLOCK_CONFIG_AREAWIDTH;
LOOKLOCK_CHAT_AREAHEIGHT			= LOOKLOCK_CONFIG_AREAHEIGHT;
LOOKLOCK_CHAT_AREAHOFF			= LOOKLOCK_CONFIG_AREAHOFF;
LOOKLOCK_CHAT_AREAVOFF			= LOOKLOCK_CONFIG_AREAVOFF;

--------------------------------------------------
--
-- Help Text
--
--------------------------------------------------
LOOKLOCK_CONFIG_INFOTEXT = {
	"    Look Lock is an addon that allows you to enter a "..
	"state where you do not have to hold down a button to "..
	"rotate your character with the mouse.  Just push the "..
	"Look Lock button, and until you push it again, your "..
	"character will rotate when you move the mouse.\n"..
	"\n"..
	"    Go to the key bindings settings to configure a key "..
	"to use for Look Lock.  There are three bindable keys:"..
	BINDING_NAME_LOOKLOCK.." - this if the primary look lock "..
	"key, press this button to enter look lock mode.\n"..
	"\n"..
	BINDING_NAME_LOOKLOCKPUSH.." - this allows you to configure "..
	"a key that will put you in look lock mode only as long as "..
	"you hold it down.\n"..
	"\n"..
	BINDING_NAME_LOOKLOCKACTION.." - this allows you to map a "..
	"key to the look lock version of the right click function.\n"..
	"\n"..
	BINDING_NAME_LOOKLOCKCAMERA.." - this allows you to map a "..
	"key to the look lock version of the left click function.\n"..
	"\n"..
	"Option Explainations:\n"..
	"\n"..
	LOOKLOCK_CONFIG_REMAP.." - if this is enabled, then the right "..
	"and left mouse buttons will behave slightly different when in "..
	"Look Lock mode.  The right button will cause you to leave "..
	"Look Lock mode, and you will get a cursor which you can then put "..
	"over an object, and when you release it will be activated.\n"..
	"The left button will leave look mode, enter camera rotation mode "..
	"and then when released will return to look mode.  If the left button "..
	"is clicked, then whatever is under the mouse cursor will be selected.\n"..
	"\n"..
	LOOKLOCK_CONFIG_STRAFE.." - if this is enabled, and "..LOOKLOCK_CONFIG_REMAP..
	" is enabled, then pressing the right and left mouse button will strafe "..
	"left and right when in Look Lock mode.\n"..
	"\n"..
	LOOKLOCK_CONFIG_SELECT.." - if enabled, then when in look lock mode, "..
	"pressing the left mouse button will give you a cursor, which you can "..
	"then point at a target with, and when you release, the target will be "..
	"selected.  Otherwise, the left button will rotate the camera, however "..
	"clicking the left button will select what is under the mouse.\n"..
	"\n"..
	LOOKLOCK_CONFIG_CURSOR.." - if enabled, then when in look lock mode, "..
	"if the camera or character are turning, and the mouse cursor has been "..
	"hidden, a targeting cursor will be shown.\n"..
	"\n"..
	"Always Look Mode has been temporarily removed.  Blizzard has broken "..
	"this feature in patch 1.6, and I may never be able to restore it.\n"..
	"\n"..
	--[[LOOKLOCK_CONFIG_ALWAYS.." - if enabled, then you will always be in "..
	"look lock mode.\nRight clicking the mouse will give you a cursor "..
	"which you can then put over an object and release to activate it.\n"..
	"Left clicking will give you a cursor which you can move over an "..
	"object to select it.  When in this mode, the Look Lock button will "..
	"switch to more normal behavior.\n"..
	"\n"..
	"This mode is imperfect, and you "..
	"should be aware that it may skrew up gameplay for you.  Blizzard "..
	"did not make it easy to make this style of interface implemented "..
	"and Look Lock must know pretty much every frame in the game so "..
	"so that it can avoid getting your mouse cursor stuck in look mode.\n"..
	"So consider this your warning, that this mode just might not work "..
	"out for you at all.  In general it works without getting the mouse "..
	"stuck, but if a frame that Look Lock doesn't know ends up under "..
	"the mouse cursor, it is likely it will get stuck.\n"..
	"\n"..
	LOOKLOCK_CONFIG_USEAREA.." - if enabled, the mouse will have to be within "..
	"the look area to re-enter look mode, when always look is on.  The look "..
	"area will be displayed, when not in look mode.\n"..
	"\n"..
	LOOKLOCK_CONFIG_AREAWIDTH.." - "..LOOKLOCK_CONFIG_AREAWIDTH_INFO.."\n"..
	"\n"..
	LOOKLOCK_CONFIG_AREAHEIGHT.." - "..LOOKLOCK_CONFIG_AREAHEIGHT_INFO.."\n"..
	"\n"..
	LOOKLOCK_CONFIG_AREAHOFF.." - "..LOOKLOCK_CONFIG_AREAHOFF_INFO.."\n"..
	"\n"..
	LOOKLOCK_CONFIG_AREAVOFF.." - "..LOOKLOCK_CONFIG_AREAVOFF_INFO.."\n"..
	"\n"..]]--
	"See page 3 for a list of slash commands.",

	"Look Lock\n"..
	"\n"..
	"By: Mugendai\n"..
	"Special Thanks:\n"..
	"    Skrag, and iecur showed me how to do this, way back during beta, "..
	"and thus allowed me to make my first addon.\n"..
	"\n"..
	"Contact: mugekun@gmail.com"
};