local basalt = require("basalt")
local colony = peripheral.find("colonyIntegrator")

if not colony or not colony.getColonyID then
    print("Colony Integrator not found or not within colony")
    return
end

local function removeSubstring(str, substr)
    local startIndex, endIndex = string.find(str, substr)

    if startIndex and endIndex then
        local prefix = string.sub(str, 1, startIndex - 1)
        local suffix = string.sub(str, endIndex + 1)
        return prefix .. suffix
    end

    return str
end

local function translateJob(input)
    local job = removeSubstring(input, "com.minecolonies.job.")
    if (job == "deliveryman") then
        return "Courier"
    end

    return job:gsub("^%l", string.upper)
end

string.lpad = function(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

local main = basalt.createFrame()
            :setTheme({FrameBG = colors.lightGray, FrameFG = colors.black})
            :setScrollable()
--main:addScrollbar()
--    :setSize(1, "parent.h"):setPosition("parent.w")

local labels = {
}

function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

basalt.schedule(function()
    while true do

        local citizens = colony.getCitizens()
        --citizens = TableConcat(citizens, citizens)
        --citizens = TableConcat(citizens, citizens)

        local labelsNeeded = #citizens * 4

        while #labels < labelsNeeded do
            local line = 2 + (#labels * 3/4)
            table.insert(labels, main:addLabel():setText(""):setPosition(2, line))
            table.insert(labels, main:addLabel():setText(""):setPosition("parent.w - 1", line))
            table.insert(labels, main:addLabel():setText(""):setPosition(2, line + 1))
            table.insert(labels, main:addLabel():setText(""):setPosition(3, line + 1))
        end

        while #labels > labelsNeeded do
            labels[#labels]:remove()
            table.remove(labels)
        end

        local line = 1
        for k, v in ipairs(citizens) do
            local gender = "F"
            if (v.gender == "male") then
                gender = "M"
            end

            local job = "Unemployed"
            if v.work then
                job = translateJob(v.work.job) .. " lvl " .. v.work.level
            end

            labels[line]
                :setText(v.name .. " (" .. gender .. ", " .. job .. ")")
                :setForeground(colors.black)

            local healthColor = colors.gray
            if v.health < v.maxHealth  then
                healthColor = colors.red
            end

            local healthText = v.health .. "/" .. v.maxHealth

            labels[line+1]
                :setText(healthText)
                :setPosition("parent.w - " .. string.len(healthText))
                :setForeground(healthColor)


            local happyString = " Happyness: " .. tostring(math.floor(v.happiness * 10)/10) .. " | "

            labels[line+2]
                :setText(happyString)
                :setForeground(colors.gray)

            local stateColor = colors.gray
            if (v.state == "Sick") then
                stateColor = colors.red
            end

            labels[line+3]
                :setText(v.state)
                :setPosition(string.len(happyString) + 2)
                :setForeground(stateColor)

            line = line + 4
        end

        sleep(1)
    end
end)()

basalt.autoUpdate()