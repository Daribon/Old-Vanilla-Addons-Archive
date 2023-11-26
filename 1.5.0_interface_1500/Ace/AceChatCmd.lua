
-- Class creation
AceChatCmdClass = AceCoreClass:new()

-- Object constructor
function AceChatCmdClass:new(commands,options)
    return ace:new(self,{commands=commands,options=options})
end


--[[---------------------------------------------------------------------------------
  Reporting Methods
------------------------------------------------------------------------------------]]

function AceChatCmdClass:result(...)
    ace:print(ace.ternary(self.addon.disabled, ACE_ADDON_DISABLED, ""),
              format(ACE_CMD_RESULT, self.addon.name, ace.concat(arg))
             )
end

function AceChatCmdClass:report(hdr,def)
    if( not def ) then def=hdr; hdr=nil end
    ace:print(hdr or format(ACE_CMD_RESULT,
                            self.addon.name.." "..ACE_CMD_REPORT_STATUS,
                            ace.ternary(self.addon.disabled, ACE_ADDON_DISABLED, ACE_ADDON_ENABLED)
                           )
             )
    local _, ref, val
    for _, ref in ipairs(def) do
        if( ref.map ) then val = ref.map[ref.val or 0]
        else val = ref.val
        end
        ace:print(format(ACE_CMD_REPORT_LINE, ref.text, val or ACE_CMD_REPORT_NO_VAL))
    end
end


--[[---------------------------------------------------------------------------------
  Command Handling Methods
------------------------------------------------------------------------------------]]

function AceChatCmdClass:Register(handler)
    if( self.registered ) then return end

    local i = 2
    local index, cmd
    local slashID = self.addon.name.."CMD"

    SlashCmdList[slashID] = function(msg) self:ProcessCommand(msg) end
    for index, cmd in ipairs(self.commands) do
        setglobal("SLASH_"..slashID..index, cmd)
    end

    self.handler = handler or self

    if( self.options ) then
        self.hasOptions = TRUE
    else
        self.options = {}
    end

    self.sorted = ace.sort(ace.GetTableKeys(self.options))
    self.options[ACE_CMD_OPT_HELP] = {desc=ACE_CMD_OPT_HELP_DESC}
    tinsert(self.sorted, 1, ACE_CMD_OPT_HELP)

    -- Add enable/disable options to the options list. This is done after the
    -- sort so that they can be kept at the top of the list. If there's no Enable
    -- method, assume the addon isn't setup for enabling/disabling.
    if( self.addon.Enable ) then
        self.options[ACE_CMD_OPT_ENABLE] = {
            desc    = format(ACE_CMD_OPT_ENABLE_DESC, self.addon.name),
            method  = "EnableAddon"
        }
        self.options[ACE_CMD_OPT_DISABLE] = {
            desc    = format(ACE_CMD_OPT_DISABLE_DESC, self.addon.name),
            method  = "DisableAddon"
        }

        if( not self.hasOptions ) then self.hasOptions = TRUE end
        tinsert(self.sorted, i,   ACE_CMD_OPT_ENABLE )
        tinsert(self.sorted, i+1, ACE_CMD_OPT_DISABLE)
        i = i + 2
    end

    if( self.handler.Report ) then
        self.options[ACE_CMD_OPT_REPORT] = {desc=ACE_CMD_OPT_REPORT_DESC,method="Report"}
        tinsert(self.sorted, i, ACE_CMD_OPT_REPORT)
    end

    -- Create a closure for printing option lines, since it's done so much
    self.printOpt   = function(l,t) ace:print(format(ACE_CMD_USAGE_OPT_DESC,l,t)) end
    self.registered = TRUE
end

function AceChatCmdClass:ProcessCommand(msg)
    msg = ace.trim(msg or "")
    local args = ace.ParseWords(msg)

    if( strlower(args[1] or "") == ACE_CMD_OPT_HELP ) then
        self:DetailedUsage(args[2])
        return
    elseif( self:ProcessOptions({}, self.options, msg) ) then
        return
    elseif( self.handler.CommandHandler ) then
        self.handler.CommandHandler(self.handler, msg)
        return
    end

    self:DisplayUsage()
end

function AceChatCmdClass:ProcessOptions(parent, def, msg)
    args = ace.ParseWords(msg)

    local opt = def[args[1] or ""]
    if( opt ) then
        if( opt.method and ((not opt.args) or (not opt.args[args[2] or ""])) ) then
            local handler = opt.handler or self.handler
            local msg = gsub(msg, args[1].."%s*", "", 1)
            handler[opt.method](handler, msg)
        elseif( opt.args ) then
            local msg = gsub(msg, args[1].."%s*", "", 1)
            self:ProcessOptions(opt, opt.args, msg)
        elseif( opt.input and (not args[1]) ) then
            self:result(ACE_CMD_OPT_NONE)
            return TRUE
        elseif( opt.method ) then
            local handler = opt.handler or self.handler
            local msg = gsub(msg, args[1].."%s*", "", 1)
            handler[opt.method](handler, msg)
        elseif( parent.method ) then
            local handler = (parent.handler or self.handler)
            handler[parent.method](handler, msg)
        end
        return TRUE
    elseif( args[1] ) then
        self:result(format(ACE_CMD_OPT_INVALID, args[1]))
        return TRUE
    elseif( parent.args ) then
        self:result(ACE_CMD_OPT_NONE)
        return TRUE
    end
end


--[[---------------------------------------------------------------------------------
  Usage Display Methods
------------------------------------------------------------------------------------]]

function AceChatCmdClass:DetailedUsage(option)
    if( option ) then
        if( self.options[option] ) then
            self:CommandHeader()
            self:OptionHeader(option)
            self:DisplayArgUsage(self.options[option])
        else
            self:DisplayUsage()
        end
    else
        self:CommandHeader()
        if( self.addon.author ) then  self.printOpt(ACE_TEXT_AUTHOR, self.addon.author) end
        if( self.addon.releaseDate ) then self.printOpt(ACE_TEXT_RELEASED, self.addon.releaseDate) end
        if( self.addon.email ) then self.printOpt(ACE_TEXT_EMAIL, self.addon.email) end
        if( self.addon.website ) then self.printOpt(ACE_TEXT_WEBSITE, self.addon.website) end
    end
end

function AceChatCmdClass:OptionHeader(option)
    local args = ACE_CMD_USAGE_NOARGS
    if( self.options[option].args ) then
        args = concat(ace.sort(ace.GetTableKeys(self.options[option].args)),
                       ACE_CMD_USAGE_OPT_SEP
                      )
    end
    ace:print(format(ACE_CMD_USAGE_OPTION,
                     ace.ternary(self.commands[2],
                                 self.commands[2],
                                 self.commands[1]
                                ),
                     option,
                     args
                    )
             )
end

function AceChatCmdClass:DisplayArgUsage(option)
    if( not option.args ) then return end
    local index, key
    for index, key in ace.sort(ace.GetTableKeys(option.args)) do
        self.printOpt(key, option.args[key].desc)
    end
end

function AceChatCmdClass:DisplayUsage()
    self:CommandHeader()

    if( not self.hasOptions ) then return end

    ace:print(format(ACE_CMD_USAGE_HEADER,
                     self.commands[1]..ace.ternary(self.commands[2],
                                                   " ("..(self.commands[2] or "")..")",
                                                   ""
                                                  ),
                     concat(self.sorted, ACE_CMD_USAGE_OPT_SEP)
                    )
             )

    -- Have to print the lines one at a time or risk it getting too large for the
    -- print buffer.
    local index, key
    for index, key in self.sorted do
        self.printOpt(key, self.options[key].desc)
    end
end

function AceChatCmdClass:CommandHeader()
    ace:print(ace.ternary(self.addon.disabled, ACE_ADDON_DISABLED, ""),
              format(ACE_CMD_USAGE_ADDON_DESC,
                     self.addon.name,
                     self.addon.version,
                     self.addon.description
                    )
             )
end
