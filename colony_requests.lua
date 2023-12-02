local basalt = require("basalt")
local colony = peripheral.find("colonyIntegrator")

if not colony or not colony.getColonyID then
    print("Colony Integrator not found or not within colony")
    return
end

local main = basalt.createFrame()
            :setTheme({FrameBG = colors.lightGray, FrameFG = colors.black})
            :setScrollable()

local labels = {
    main:addLabel():setText(""):setPosition(2, 2):setForeground(colors.gray)
}

basalt.schedule(function()
    while true do
        local requests = colony.getRequests()
        local labelsNeeded = 1 + (#requests * 1)

        while #labels < labelsNeeded do
            local line = #labels + 2
            table.insert(labels, main:addLabel():setText(""):setPosition(2, line))
        end

        while #labels > labelsNeeded do
            labels[#labels]:remove()
            table.remove(labels)
        end

        if #requests > 0 then
            labels[1]:setText("Requests: " .. #requests)
        else
            labels[1]:setText("There are no open requests at this time.")
        end

        local line = 2
        for k, v in ipairs(requests) do
            labels[line]
                :setText(v.count .. "x " .. v.name  .. " for " .. v.target)

            line = line + 1
        end

        sleep(1)
    end
end)()

basalt.autoUpdate()