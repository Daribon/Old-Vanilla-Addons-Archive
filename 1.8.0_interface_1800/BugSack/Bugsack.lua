-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--
-- Chapter I: Localized Constants.                       --
-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--

if not ace:LoadTranslation("BugSack") then

--<< ================================================= >>--
-- Page I: Keybindings.                                  --
--<< ================================================= >>--

BINDING_HEADER_BUGSACK    = "BugSack"
BINDING_NAME_BUGSACK_SHOW = "Show"

--<< ================================================= >>--
-- Page II: Chat Options.                                --
--<< ================================================= >>--

BugSackConst          = {

   ChatCmd            = {"/bugsack", "/bs"},

   ChatOpt            = {
      {
         option       = "show",
         desc         = "show the BugSack display frame.",
         method       = "ShowFrame"
      },
      {
         option       = "save",
         desc         = "toggle whether to save bugs or not.",
         method       = "Save"
      },
      {
         option       = "sound",
         desc         = "enable/disable audible warning.",
         method       = "Sound"
      },
      {
         option       = "list",
         desc         = "list the current-session errors.",
         method       = "ListErrors",
         args         = {
            {
               option = "all",
               desc   = "list all the errors."
            },
            {
               option = "previous",
               desc   = "list previous errors."
            },
            {
               option = "#",
               desc   = "list from session #."
            }
         }
      },
      {
         option       = "bug",
         desc         = "generate a fake bug (testing).",
         method       = "Bug",
         input        = TRUE,
         args         = {
            {
               option = "script",
               desc   = "generate a script bug.",
               method = "ScriptBug"
            },
            {
               option = "addon",
               desc   = "generate an Addon bug.",
               method = "AddonBug"
            }
         }
      },
      {
         option       = "reset",
         desc         = "clear out the errors database.",
         method       = "Reset"
      }
   },

--<< ================================================= >>--
-- Page III: AddOn Information.                          --
--<< ================================================= >>--

   Team    = "The BugSack Team",
   Name    = "BugSack",
   Version = "a/R.2b",
   Desc    = "Toss those bugs inna sack.",

--<< ================================================= >>--
-- Page IV: Chat Option Variables.                       --
--<< ================================================= >>--

   Chat_SaveErrors  = "Permanent saving is [%s].",
   Chat_ToggleSound = "Audible warnings are [%s].",
   Chat_ListTitle   = "List of Errors",
   Chat_GenError    = "BugSack generated this fake error.",
   Chat_Generated   = "An error has been generated.",
   Chat_Cleared     = "All errors were wiped.",

--<< ================================================= >>--
-- Page V: Miscellaneous Function Variables.             --
--<< ================================================= >>--

   Misc_ErrorNotice = "An error has been recorded.",

}

--<< ================================================= >>--
-- Page VI: Register Shared Constants.                   --
--<< ================================================= >>--

ace:RegisterGlobals({
   version  = 1.0,
   ACEG_ON  = "On",
   ACEG_OFF = "Off",
   ACE_HEX  = {0,1,2,3,4,5,6,7,8,9,"a","b","c","d","e","f"},
})

--<< ================================================= >>--
-- Page Omega: Closure.                                  --
--<< ================================================= >>--

end

-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--
-- Chapter II: Addon Object and Functions.               --
-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--

--<< ================================================= >>--
-- Page I: Initialize the AddOn Object.                  --
--<< ================================================= >>--

local const      = BugSackConst
local tmperrDB   = {}

BugSack          = AceAddonClass:new({
   name          = const.Name,
   version       = const.Version,
   description   = const.Desc,
   author        = const.Team,
   aceCompatible = "102",
   category      = ACE_CATEGORY_INTERFACE,
   db            = AceDbClass:new("BugSackDB"),
   defaults      = { save = 1, sound = 0, errors = {} },
   cmd           = AceChatCmdClass:new(const.ChatCmd, const.ChatOpt),

--<< ================================================= >>--
-- Page II(a): The Enable Function.                      --
-- Page II(b): Hook/Replace the Error Functions.         --
--<< ================================================= >>--

   Enable = function(self)
      self:Set("session", (self:Get("session") or 0) + 1)
      ScriptErrors_Message.SetText = function(_, err) self:Error(err) end
      ScriptErrors.Show            = function() end
		for k, v in tmperrDB do self:Error(v) end
		tmperrDB = nil
   end,
   
   Disable = function(self)
      ScriptErrors_Message.SetText = nil
      ScriptErrors.Show            = nil
   end,

--<< ================================================= >>--
-- Page III: The Chat Options.                           --
--<< ================================================= >>--

   ListErrors = function(self, i)
      local tmpDB, cs = {}, self:Get("session")
      local db = self:Get("save") and self:Get("errors") or sef.tmperrDB or {}
      local title = self.ColorText({250, 250, 170}, const.Name..": ")..
                    const.Chat_ListTitle
      ace:print(title) for _, v in db do
         local _, _, ses = strfind(v, "-(.+)] ")
         if i == "all" or i == "" and cs == tonumber(ses)
         or i == "previous" and cs - 1 == tonumber(ses)
         or ses == i then v = "- "..v ace:print(v) end
      end
   end,
   
   ShowFrame = function(self)
      local cs = self:Get("session")
      local db = self:Get("save") and self:Get("errors") or self.errDB or {}
		self.str = ""
		for _, v in db do
         local _, _, ses = strfind(v, "-(.+)] ")
         if cs == tonumber(ses) then
         	self.str = self.str..v.."\n"
         end
      end
		BugSackFrame:Show() BugSackFrameScroll:Show()
      BugSackFrameScrollText:SetText(self.str)
      BugSackFrameScrollText:ClearFocus()
   end,
   
   Save = function(self)
      self:Tog("save", const.Chat_SaveErrors)
   end,
   
   Sound = function(self)
      self:Tog("sound", const.Chat_ToggleSound)
   end,

   ScriptBug = function(self)
      RunScript(const.Chat_GenError)
      self:Msg(const.Chat_Generated)
   end,
   
   AddonBug = function(self)
      self:Msg(const.Chat_Generated)
      self:BugGeneratedByBugSack()
   end,

   Reset = function(self)
      self.db:reset(self.profilePath, self.defaults)
      self:Msg(const.Chat_Cleared) self:Enable()
   end,

--<< ================================================= >>--
-- Page IV: The Error Sacking Function.                  --
--<< ================================================= >>--

   Error = function(self, err)
      local db = self:Get("save") and self:Get("errors") or self.errDB or {}
      local cs = self:Get("session")
      err      = gsub(err, "[Ii]nterface\\", "")
      err      = gsub(err, "[Aa]dd[Oo]ns\\", "")
      local oe = err
      err      = "["..date("%H:%M").."-"..cs.."] "..err.."\n   ---"
      for _, v in db do
         local _, _, ses, ee = strfind(v, "-(.+)] (.+)\n")
         if cs == tonumber(ses) and ee == oe then
            return
         end
      end tinsert(db, err)
      if self:Get("sound") then
         PlaySoundFile("Interface\\AddOns\\BugSack\\error.wav")
      end
      self:Msg(BugSackConst.Misc_ErrorNotice, "")
      if not self:Get("save") then self.errDB = db
      else self:Set("errors", db) end
   end

})

--<< ================================================= >>--
-- Page V: The Temporary Hooks.                          --
--<< ================================================= >>--

ScriptErrors_Message.SetText = function(_, err)
	tinsert(tmperrDB, err)
end

ScriptErrors.Show            = function() end

--<< ================================================= >>--
-- Page Omega: Register the AddOn Object.                --
--<< ================================================= >>--

BugSack:RegisterForLoad()

-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--
-- Chapter III: Register Shared Util Functions.          --
-->> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <<--

ace:RegisterFunctions(BugSack, {
   version = 1.0,

--<< ================================================= >>--
-- Page I: The Addon Closures.                           --
--<< ================================================= >>--

   Msg       = function(self, ...)
   	self.cmd:msg(unpack(arg))
   end,
   Get       = function(self, var)
      return self.db:get(self.profilePath, var)
   end,
   Set       = function(self, var, val)
      self.db:set(self.profilePath, var, val)
   end,
   Tog       = function(self, v, c)
      self.cmd:result(format(c, self.db:toggle(
      self.profilePath, v) and ACEG_ON or ACEG_OFF))
   end,

--<< ================================================= >>--
-- Page I: The Colourizer Functions.                     --
--<< ================================================= >>--

   HexDigit  = function(i)
      return ACE_HEX[floor(i/16)+1]..ACE_HEX[mod(i,16)+1]
   end,
   ColorText = function(c,...)
      if not c then return ace.concat(arg) end
      if type(c)=="table" then
         return "|cff"..ace.HexDigit(c[1] or c.r)..ace.HexDigit(c[2] or c.g)..
          ace.HexDigit(c[3] or c.b)..ace.concat(arg).."|r"
      end
      return "|cff"..c..ace.concat(arg).."|r"
   end

})
