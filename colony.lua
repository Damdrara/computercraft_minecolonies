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

local menubar = main:addMenubar()
    :setSize("parent.w")
    :onChange(function(self, val)
        local index = self:getItemIndex()
        openSubFrame(index)
    end)

local termWidth, termHeight = term.getSize()

if (termWidth < 30) then
    menubar:addItem("St")
    menubar:addItem("Ci")
    menubar:addItem("Rq")
    menubar:addItem("WO")
else
    menubar:addItem("Stats")
    menubar:addItem("Citizens")
    menubar:addItem("Requests")
    menubar:addItem("WorkOrders")
end

local function renderProgram(subId, program, addHeadline, headline)
    sub[subId]:addProgram()
        :setPosition(1, 1)
        :setSize("parent.w", "parent.h")
        :execute(program)
end

renderProgram(1, "colony_stats.lua")
renderProgram(2, "colony_citizens.lua")
renderProgram(3, "colony_requests.lua")
renderProgram(4, "colony_workorders.lua")

local time = main:addLabel():setText("--:--"):setPosition("parent.w - 5", 1):setZIndex(99)

basalt.schedule(function()
    while true do
        local osTime = os.time()
        local sTime = textutils.formatTime(osTime, true)
        sTime = strLpad(sTime, 5, " ")
        time:setText(sTime)
        if osTime > 18.32 or osTime < 6.0 then
            time:setForeground(colors.red)
        else
            time:setForeground(colors.black)
        end
        sleep(1)
    end
end)()

basalt.autoUpdate()
