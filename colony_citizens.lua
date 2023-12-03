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

basalt.schedule(function()
    while true do

        local citizens = colony.getCitizens()

        local labelsNeeded = #citizens * 5

        while #labels < labelsNeeded do
            local line = #labels + 2
            table.insert(labels, main:addLabel():setText(""):setPosition(2, line))
            table.insert(labels, main:addLabel():setText(""):setPosition(3, line + 1))
            table.insert(labels, main:addLabel():setText(""):setPosition(3, line + 2))
            table.insert(labels, main:addLabel():setText(""):setPosition(3, line + 2))
            table.insert(labels, main:addLabel():setText(""):setPosition(3, line + 3))
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
                :setText(v.name)
                :setForeground(colors.black)

            labels[line + 1]
                :setText(gender .. ", " .. job)
                :setForeground(colors.black)

            local happyString = "Happyness: " .. tostring(math.floor(v.happiness * 10)/10) .. " | "

            labels[line+2]
                :setText(happyString)
                :setForeground(colors.gray)

            local healthColor = colors.gray
            if v.health < v.maxHealth  then
                healthColor = colors.red
            end

            local healthText = v.health .. "/" .. v.maxHealth

            labels[line+3]
                :setText(healthText)
                :setPosition(string.len(happyString) + 3)
                :setForeground(healthColor)

            local stateColor = colors.gray
            if (v.state == "Sick") then
                stateColor = colors.red
            end

            labels[line+4]
                :setText(v.state)
                :setForeground(stateColor)

            line = line + 5
        end

        sleep(1)
    end
end)()

basalt.autoUpdate()