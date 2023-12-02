local basalt = require("basalt")
local colony = peripheral.find("colonyIntegrator")

if not colony or not colony.getColonyID then
    print("Colony Integrator not found or not within colony")
    return
end

local main = basalt.createFrame()
    :setTheme({FrameBG = colors.lightGray, FrameFG = colors.black})
    --:setMonitor("top")

local sub = {
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"),
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
}

local function strLpad(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

local function openSubFrame(id)
    if(sub[id]~=nil)then
        for k,v in pairs(sub)do
            v:hide()
        end
        sub[id]:show()
    end
end

local function renderStats()
    sub[1]:addProgram()
        :setPosition(1, 1)
        :setSize("parent.w", "parent.h")
        :execute("colony_stats.lua")
end

local function renderColonists()
    sub[2]:addProgram()
        :setPosition(1, 1)
        :setSize("parent.w", "parent.h")
        :execute("colony_citizens.lua")
end

local function renderRequests()
    sub[3]:addProgram()
        :setPosition(1, 1)
        :setSize("parent.w", "parent.h")
        :execute("colony_requests.lua")
end

local function renderWorkOrders()
    sub[4]:addProgram()
        :setPosition(1, 1)
        :setSize("parent.w", "parent.h")
        :execute("colony_workorders.lua")
end


local menubar = main:addMenubar()
    :setSize("parent.w")
    :onChange(function(self, val)
        local index = self:getItemIndex()
        openSubFrame(index)
    end)
    :addItem("Stats")
    :addItem("Citizens")
    :addItem("Requests")
    :addItem("WorkOrders")


renderStats()
renderColonists()
renderRequests()
renderWorkOrders()

local time = main:addLabel():setText("--:--"):setPosition("parent.w - 5", 1):setZIndex(99)

basalt.schedule(function()
    while true do
        local sTime = textutils.formatTime(os.time(), true)
        sTime = strLpad(sTime, 5, " ")
        time:setText(sTime)
        sleep(1)
    end
end)()

basalt.autoUpdate()
